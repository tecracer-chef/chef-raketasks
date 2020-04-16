#
# ChefRake::Task::Test
# Add tasks for testing integration, style and unit
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Test < ::Rake::TaskLib
      def initialize

        namespace :test do
          desc 'Run all integration tests'
          task :integration => [
            :'integration:ec2',
            :'integration:physical',
            :'integration:vagrant',
            :'integration:vcenter',
          ]

          namespace :integration do

            def kitchen_instances(regexp, config)
              # Gets a collection of instances.
              #
              # @param regexp [String] regular expression to match against instance names.
              # @param config [Hash] configuration values for the `Kitchen::Config` class.
              # @return [Collection<Instance>] all instances.
              active_config = Kitchen::Config.new(config)
              # If we are in CI mode then add formatter options (@refactor)
              kitchen_config = active_config.send(:data).send(:data)
              kitchen_config[:verifier][:reporter] = ['junit:reports/integration/inspec_%{platform}_%{suite}.xml'] if ENV['CI']
              instances = active_config.instances
              return instances if regexp.nil? || regexp == 'all'
              instances.get_all(Regexp.new(regexp))
            end

            def run_kitchen(action, regexp, loader_config = {})
              # Runs a test kitchen action against some instances.
              #
              # @param action [String] kitchen action to run (defaults to `'test'`).
              # @param regexp [String] regular expression to match against instance names.
              # @param loader_config [Hash] loader configuration options.
              # @return void
              action = 'test' if action.nil?
              require 'kitchen'
              Kitchen.logger = Kitchen.default_file_logger
              config = { loader: Kitchen::Loader::YAML.new(loader_config) }
              kitchen_instances(regexp, config).each { |i| i.send(action) }
            rescue Exception => e
              # Clean up on any error
              kitchen_instances(regexp, config).each { |i| i.send('destroy') }
            end

            desc 'Run integration tests on AWS EC2'
            task :ec2, [:regexp, :action] do |_t, args|
              run_kitchen(args.action, args.regexp, local_config: '.kitchen.ec2.yml')
            end

            desc 'Run integration tests using static IPs'
            task :static, [:regexp, :action] do |_t, args|
              run_kitchen(args.action, args.regexp, local_config: '.kitchen.static.yml')
            end

            desc 'Run integration tests locally with vagrant'
            task :vagrant, [:regexp, :action] do |_t, args|
              run_kitchen(args.action, args.regexp, local_config: '.kitchen.vagrant.yml')
            end

            desc 'Run integration tests using vCenter'
            task :vcenter, [:regexp, :action] do |_t, args|
              run_kitchen(args.action, args.regexp, local_config: '.kitchen.vcenter.yml')
            end

          end # namespace integration

          namespace :lint do
            desc 'Run linting tests for cookbook'
            task :cookbook do
              puts 'running cookstyle for cookbook'
              puts `cookstyle`
            end

          end # namespace lint

          namespace :unit do
            desc 'Run ChefSpec unit tests for cookbook'
            task :cookbook do
              begin
                require 'rspec/core/rake_task'
                RSpec::Core::RakeTask.new(:unit) do |t|
                  # If we are in CI mode then add formatter options
                  t.rspec_opts = ENV['CI'] ? '--format RspecJunitFormatter --out reports/unit/chefspec.xml' : '--color --format progress'
                  t.pattern = 'test/unit/**{,/*/**}/*_spec.rb'
                end
              rescue Exception => e
                puts ">>> Gem load error: #{e}, omitting tests:unit" unless ENV['CI']
              end
            end

          end # namespace unit

        end # namespace test

      end # def initialize
    end # class Test
  end # module RakeTasks
end # module Chef

ChefRake::Task::Test.new
