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
        end # namespace test
      end # def initialize
    end # class Test
  end # module RakeTasks
end # module Chef

ChefRake::Task::Test.new
