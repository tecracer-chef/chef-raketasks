#
# ChefRake::Task::Package
# Add tasks for packing cookbooks, InSpec profiles or policyfiles
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Package < ::Rake::TaskLib
      def initialize

        namespace :package do

          desc 'Package cookbook as .tgz file'
          task :cookbook do
            begin
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
            rescue Exception => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end

          desc 'Package InSpec profile as .tgz file'
          task :inspec do
            begin
              # Berkshelf::Packager does not use chefignore, so a cleanup is necessary before
              Rake::Task["clean:inspec"].execute

              require 'inspec'
              require 'train'
              current_dir = Rake.application.original_dir
              pkg_path = File.join(current_dir, 'pkg')

              data = File.read(File.join(current_dir, 'inspec.yml'))
              metadata = Inspec::Metadata.from_yaml(nil, data, nil)
              file_name = format('inspecprofile-%<name>s-%<version>s.tar.gz', metadata.params.to_hash.transform_keys(&:to_sym))
              pkg_rel_path = File.join('pkg', file_name)
              abs_path = File.join(current_dir, pkg_rel_path)

              Dir.mkdir(pkg_path) unless Dir.exist?(pkg_path)
              Dir.mkdir(ENV['HOME']+'/.inspec/cache') unless Dir.exist?(ENV['HOME']+'/.inspec/cache')

              cmd = Train.create("local", command_runner: :generic).connection
              command = 'inspec'
              command << ' archive ' + current_dir
              command << ' --overwrite'
              command << ' --output ' + abs_path
              # command << ' --vendor-cache=' + ENV['HOME'] + "/.inspec/cache" # looks like this has an error in main code

              puts command
              cmd.run_command(command)

              printf("InSpec Profile(s) packaged to %s (size %d bytes)\n", abs_path, File.size(abs_path))
            rescue Exception => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end

          namespace :policyfile do
            desc 'Generate new policyfile lock'
            task :install do
              begin
                # Rake::Task["clean:policyfile"].execute
                current_dir = Rake.application.original_dir

                require 'chef-cli/cli'
                policyfile_rel_path = "Policyfile.rb"
                policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

                cli = ChefCLI::CLI.new(['install', policyfile_full_path])
                subcommand_name, *subcommand_params = cli.argv
                subcommand = cli.instantiate_subcommand(subcommand_name)
                subcommand.run_with_default_options(subcommand_params)
              rescue Exception => e
                puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
              end
            end

            desc 'Update current policyfile.lock.json'
            task :update do
              begin
                current_dir = Rake.application.original_dir
                require 'chef-cli/cli'

                policyfile_rel_path = "Policyfile.rb"
                policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

                cli = ChefCLI::CLI.new(['update', policyfile_full_path])

                subcommand_name, *subcommand_params = cli.argv
                subcommand = cli.instantiate_subcommand(subcommand_name)
                subcommand.run_with_default_options(subcommand_params)
              rescue Exception => e
                puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
              end
            end

            desc 'Pack current policyfile.lock.json'
            task :pack do
              begin
                current_dir = Rake.application.original_dir

                require 'chef-cli/cli'
                policyfile_rel_path = "Policyfile.rb"
                policyfile_full_path = File.expand_path(policyfile_rel_path, current_dir)

                cli = ChefCLI::CLI.new(['update', policyfile_full_path])
                binding.pry
                subcommand_name, *subcommand_params = cli.argv
                subcommand = cli.instantiate_subcommand(subcommand_name)
                subcommand.run_with_default_options(subcommand_params)
              rescue Exception => e
                puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
              end
            end
          end # namespace policyfile
        end # namespace package

      end # def initialize
    end # class Package
  end # module RakeTasks
end # module Chef

ChefRake::Task::Package.new
