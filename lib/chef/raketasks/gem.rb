#
# ChefRake::Task::Gem
# Add tasks for installing gems
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Gem < ::Rake::TaskLib
      def initialize

        namespace :gem do
          desc 'gem:install'
          namespace :install do

            def install_gem(name, version, source)
              cmd = "chef gem install "
              cmd << name + " "
              cmd << "-v #{version} " unless version.nil?
              cmd << "-s #{source} " unless source.nil?
              cmd << "--no-document"

              sh cmd
            end

            # NAMESPACE: gem:install:generator
            desc 'Installs all Cookbook generators'
            task :generator => [
              :'gem:install:generator:appinstall',
              :'gem:install:generator:tenv',
            ]
            namespace :generator do
              desc 'Installs cookbook generator for appinstall'
              task :appinstall, [:version, :source] do |_t, args|
                install_gem('sgre-appinstall-chef-generator', args.version, args.source)
              end

              desc 'Installs cookbook generator for tenv'
              task :appinstall, [:version, :source] do |_t, args|
                puts 'your installer could be placed here'
              end
            end

            # NAMESPACE: gem:install:static
            desc 'Installs necessary static gems for kitchen'
            task :static => [
              :'gem:install:static:kitchen',
            ]
            namespace :static do
              desc 'Installs kitchen-static for kitchen'
              task :kitchen, [:version, :source] do |_t, args|
                install_gem('kitchen-static', args.version, args.source)
              end
            end

            # NAMESPACE: gem:install:vcenter
            desc 'Installs necessary vcenter gems for kitchen'
            task :vcenter => [
              :'gem:install:vcenter:sdk',
              :'gem:install:vcenter:kitchen',
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
        end # namespace gem

      end # def initialize
    end # class Gem
  end # module RakeTasks
end # module Chef

ChefRake::Task::Gem.new
