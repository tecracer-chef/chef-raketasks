#
# Author:: Patrick Schaumburg (<pschaumburg@tecracer.de>)
# Author:: Thomas Heinen (<theinen@tecracer.de>)
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
    class Package < ::Rake::TaskLib
      def initialize

        namespace :package do
          desc 'Package cookbook as .tgz file'
          task :cookbook do
            # Berkshelf::Packager does not use chefignore, so a cleanup is necessary before
            Rake::Task['clean:cookbook'].execute

            require 'berkshelf'
            current_dir = Rake.application.original_dir
            metadata = Chef::Cookbook::Metadata.new
            metadata.from_file File.join(current_dir, 'metadata.rb')
            file_name = format('cookbook-%<name>s-%<version>s.tar.gz', metadata.to_hash.transform_keys(&:to_sym))
            rel_path = File.join('pkg', file_name)
            abs_path = File.join(current_dir, rel_path)
            # Clean up and prepare
            Dir.mkdir('pkg') unless Dir.exist?('pkg')
            packager = Berkshelf::Packager.new abs_path
            packager.run(current_dir)
            printf("Cookbook(s) packaged to %s (size %d bytes)\n", rel_path, File.size(rel_path))

          rescue StandardError => e
            puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
          end

          desc 'Package InSpec profile as .tgz file'
          task :inspec do
            # Berkshelf::Packager does not use chefignore, so a cleanup is necessary before
            Rake::Task['clean:inspec'].execute

            require 'inspec'
            require 'train'
            current_dir = Rake.application.original_dir
            pkg_path = File.join(current_dir, 'pkg')

            data = File.read(File.join(current_dir, 'inspec.yml'))
            metadata = Inspec::Metadata.from_yaml(nil, data, nil)
            metadata_as_hash = metadata.params.to_hash.transform_keys(&:to_sym)
            file_name = format('inspecprofile-%<name>s-%<version>s.tar.gz', metadata_as_hash)
            pkg_rel_path = File.join('pkg', file_name)
            abs_path = File.join(current_dir, pkg_rel_path)

            Dir.mkdir(pkg_path) unless Dir.exist?(pkg_path)
            Dir.mkdir(ENV['HOME'] + '/.inspec/cache') unless Dir.exist?(ENV['HOME'] + '/.inspec/cache')

            cmd = Train.create('local', command_runner: :generic).connection
            command = 'inspec'
            command << ' archive ' + current_dir
            command << ' --overwrite'
            command << ' --output ' + abs_path
            # command << ' --vendor-cache=' + ENV['HOME'] + "/.inspec/cache" # looks like this has an error in main code

            puts command
            cmd.run_command(command)

            printf("InSpec Profile(s) packaged to %s (size %d bytes)\n", abs_path, File.size(abs_path))

          rescue StandardError => e
            puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
          end

          namespace :policyfile do
            desc 'Generate new policyfile lock'
            task :install do
              # Rake::Task["clean:policyfile"].execute
              current_dir = Rake.application.original_dir

              require 'chef-cli/cli'
              policyfile_rel_path = 'Policyfile.rb'
              policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

              cli = ChefCLI::CLI.new(['install', policyfile_full_path])
              subcommand_name, *subcommand_params = cli.argv
              subcommand = cli.instantiate_subcommand(subcommand_name)
              subcommand.run_with_default_options(subcommand_params)

            rescue StandardError => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end

            desc 'Update current policyfile.lock.json'
            task :update do
              current_dir = Rake.application.original_dir
              require 'chef-cli/cli'

              policyfile_rel_path = 'Policyfile.rb'
              policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

              cli = ChefCLI::CLI.new(['update', policyfile_full_path])

              subcommand_name, *subcommand_params = cli.argv
              subcommand = cli.instantiate_subcommand(subcommand_name)
              subcommand.run_with_default_options(subcommand_params)

            rescue StandardError => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end

            desc 'Pack current policyfile.lock.json'
            task :pack do
              current_dir = Rake.application.original_dir

              require 'chef-cli/cli'
              policyfile_rel_path = 'Policyfile.rb'
              policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

              cli = ChefCLI::CLI.new(['update', policyfile_full_path])

              subcommand_name, *subcommand_params = cli.argv
              subcommand = cli.instantiate_subcommand(subcommand_name)
              subcommand.run_with_default_options(subcommand_params)

            rescue StandardError => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end # namespace policyfile
        end # namespace package
      end # def initialize
    end # class Package
  end # module RakeTasks
end # module Chef

ChefRake::Task::Package.new
