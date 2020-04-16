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
    class Clean < ::Rake::TaskLib
      def initialize

        namespace :clean do
          desc 'Removes cache dirs from any local chef installation'
          task :chefcache do
            cachedirs = [
              ENV['HOME'] + '/.chef/cache',
              ENV['HOME'] + '/.chefdk/cache',
              ENV['HOME'] + '/.chef-workstation/cache'
            ]
            cachedirs.each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end

          desc 'Removes any temporary files from a cookbook'
          task :cookbook do
            %w[
              Berksfile.lock
              .bundle
              .cache
              coverage
              doc/
              Gemfile.lock
              .kitchen
              metadata.json
              pkg/
              policies/*.lock.json
              *.lock.json
              reports/
              rspec.xml
              vendor
              .yardoc
              .DS_Store
            ].each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end

          desc 'Removes any temporary files from an InSpec profile'
          task :inspec do
            %w[
              inspec.lock
              coverage
              doc/
              Gemfile.lock
              pkg/
              reports/
              rspec.xml
              vendor
              .yardoc
              .DS_Store
            ].each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end
        end

        task clean: :'clean:cookbook'

      end # def initialize
    end # class Clean
  end # module RakeTasks
end # module Chef

ChefRake::Task::Clean.new
