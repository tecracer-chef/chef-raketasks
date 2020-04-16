#
# ChefRake::Task::Release
# Add tasks for release packages to artifactory or supermarket
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Release < ::Rake::TaskLib
      def initialize

        namespace :release do
          desc 'Upload to Artifactory'
          task :artifactory, [:endpoint, :apikey, :repokey, :path] do |_t, args|
            begin
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
              targetpath = args.path + '/' + file_name

              artifact = Artifactory::Resource::Artifact.new(local_path: abs_path)
              upload = artifact.upload(args.repokey, targetpath)

              printf("Cookbook released to %s (size %d bytes)\n", upload.uri, upload.size)
              printf("SHA256 Checksum: %s\n", upload.checksums['sha256'])

            rescue Exception => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end

          desc 'Upload to Chef Server'
          task :chefserver do
            begin
              Rake::Task['clean:cookbook'].execute

              require 'berkshelf'
              current_dir = Rake.application.original_dir
              parent_dir = File.expand_path("..", current_dir)
              metadata = Chef::Cookbook::Metadata.new
              metadata.from_file File.join(current_dir, 'metadata.rb')

              cmd = "knife cookbook upload #{metadata.name} --freeze"
              cmd << " --cookbook-path #{parent_dir}"
              sh cmd

            rescue Exception => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end

          desc 'Upload to Chef Supermarket'
          task :supermarket do
            begin
              Rake::Task['clean:cookbook'].execute

              require 'berkshelf'
              current_dir = Rake.application.original_dir
              parent_dir = File.expand_path("..", current_dir)
              metadata = Chef::Cookbook::Metadata.new
              metadata.from_file File.join(current_dir, 'metadata.rb')

              cmd = "knife supermarket share #{metadata.name}"
              cmd << " --cookbook-path #{parent_dir}"
              sh cmd

              # require 'chef/mixin/shell_out'
              # require 'chef/knife/supermarket_share'

            rescue Exception => e
              puts ">>> Gem load error: #{e}, omitting package" unless ENV['CI']
            end
          end
        end

      end # def initialize
    end # class Release
  end # module RakeTasks
end # module Chef

ChefRake::Task::Release.new
