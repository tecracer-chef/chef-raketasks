#
# Author:: Patrick Schaumburg (<pschaumburg@tecracer.de>)
# Copyright:: Copyright 2020, tecRacer Group
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Gem < ::Rake::TaskLib
      def initialize
        super

        namespace :gem do
          def install_gem(name, version, source, installdir)
            cmd = 'chef gem install '
            cmd << "#{name} "
            cmd << "-v \"#{version}\" " unless version.nil?
            cmd << "-s #{source} " unless source.nil?
            cmd << "--install-dir #{installdir} " unless installdir.nil? # used mostly for vendoring
            cmd << '--no-user-install ' unless installdir.nil? # used for vendoring
            cmd << '--no-document'

            sh cmd
          end

          desc 'gem:install'
          namespace :install do
            # NAMESPACE: gem:install:static
            desc 'Installs necessary static gems for kitchen'
            task static: %i[
              gem:install:static:kitchen
            ]
            namespace :static do
              desc 'Installs kitchen-static for kitchen'
              task :kitchen, [:version, :source] do |_t, args|
                install_gem('kitchen-static', args.version, args.source)
              end
            end

            # NAMESPACE: gem:install:vcenter
            desc 'Installs necessary vcenter gems for kitchen'
            task vcenter: %i[
              gem:install:vcenter:sdk
              gem:install:vcenter:kitchen
            ]
            namespace :vcenter do
              desc 'Installs vcenter sdk for kitchen'
              task :sdk, [:version, :source] do |_t, args|
                install_gem('vsphere-automation-sdk', args.version, args.source)
              end

              desc 'Installs kitchen-vcenter for kitchen'
              task :kitchen, [:version, :source] do |_t, args|
                install_gem('kitchen-vcenter', args.version, args.source)
              end
            end # namespace vcenter
          end # namespace install

          # NAMESPACE: gem:vendor
          desc 'Vendors gems into cookbook'
          task :vendor, [:gemname, :version, :source, :installdir] do |_t, args|
            args.with_defaults(
              version: '>= 0', # so use latest when not set
              source: nil,
              installdir: 'files/default/vendor'
            )

            install_gem(args.gemname, args.version, args.source, args.installdir)
          end
        end # namespace gem
      end # def initialize
    end # class Gem
  end # module RakeTasks
end # module Chef

ChefRake::Task::Gem.new
