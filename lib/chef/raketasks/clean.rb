#
# ChefRake::Task::Clean
# Add tasks for cleanup dirs
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
              ENV['HOME'] + "/.chef/cache",
              ENV['HOME'] + "/.chefdk/cache",
              ENV['HOME'] + "/.chef-workstation/cache"
            ]
            cachedirs.each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end

          desc 'Removes any temporary files from a cookbook'
          task :cookbook do
            %w(
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
            ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end

          desc 'Removes any temporary files from an InSpec profile'
          task :inspec do
            %w(
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
            ).each { |f| FileUtils.rm_rf(Dir.glob(f)) }
          end
        end

        task :clean => :'clean:cookbook'

      end # def initialize
    end # class Clean
  end # module RakeTasks
end # module Chef

ChefRake::Task::Clean.new
