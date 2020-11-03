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
    class Release < ::Rake::TaskLib
      def initialize
        super

        namespace :release do
          desc 'Upload to Artifactory'
          task :artifactory, [:endpoint, :apikey, :repokey, :path] do |_t, args|
            Rake::Task['package:cookbook'].execute

            require 'berkshelf'
            current_dir = Rake.application.original_dir
            metadata = Chef::Cookbook::Metadata.new
            metadata.from_file File.join(current_dir, 'metadata.rb')
            file_name = format('cookbook-%<name>s-%<version>s.tar.gz', metadata.to_hash.transform_keys(&:to_sym))
            rel_path = File.join('pkg', file_name)
            abs_path = File.join(current_dir, rel_path)

            require 'artifactory'
            Artifactory.endpoint = args.endpoint # @TODO: Remove trailing slash, if exist
            Artifactory.api_key = args.apikey
            targetpath = File.join(args.path, file_name)

            artifact = Artifactory::Resource::Artifact.new(local_path: abs_path)
            upload = artifact.upload(args.repokey, targetpath)

            printf("Cookbook released to %s (size %d bytes)\n", upload.uri, upload.size)
            printf("SHA256 Checksum: %s\n", upload.checksums['sha256'])

          rescue StandardError => e
            puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
          end

          desc 'Upload to Chef Server'
          task :chefserver do
            Rake::Task['clean:cookbook'].execute

            require 'berkshelf'
            current_dir = Rake.application.original_dir
            parent_dir = File.expand_path('..', current_dir)
            metadata = Chef::Cookbook::Metadata.new
            metadata.from_file File.join(current_dir, 'metadata.rb')

            cmd = "knife cookbook upload #{metadata.name} --freeze"
            cmd << " --cookbook-path #{parent_dir}"
            sh cmd

          rescue StandardError => e
            puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
          end

          desc 'Upload to Chef Supermarket'
          task :supermarket do
            Rake::Task['clean:cookbook'].execute

            require 'berkshelf'
            current_dir = Rake.application.original_dir
            parent_dir = File.expand_path('..', current_dir)
            metadata = Chef::Cookbook::Metadata.new
            metadata.from_file File.join(current_dir, 'metadata.rb')

            cmd = "knife supermarket share #{metadata.name}"
            cmd << " --cookbook-path #{parent_dir}"
            sh cmd

            # require 'chef/mixin/shell_out'
            # require 'chef/knife/supermarket_share'

          rescue StandardError => e
            puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
          end
        end # namespace release
      end # def initialize
    end # class Release
  end # module RakeTasks
end # module Chef

ChefRake::Task::Release.new
