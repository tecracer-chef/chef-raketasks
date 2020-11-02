#
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
    class Repin < ::Rake::TaskLib
      def initialize
        super

        namespace :repin do
          desc 'Repin hard dependencies in Chef Workstation binaries'

          %w[chef-client kitchen inspec ohai].each do |binary|
            next unless File.exist? binary_wrapper(binary)

            desc "Repin #{binary} dependency to a specific gem"
            task binary.to_sym, [:gem, :version] do |_task, args|
              task_repin binary, args.gem, args.version
            end
          end
        end # namespace repin
      end # def initialize

      def task_repin(name, gem, version)
        read binary_wrapper(name)
        repin gem, version
        write_back
      end

      def binary_wrapper(name)
        File.join('/opt/chef-workstation/bin', name)
      end

      def read(filename)
        @contents = File.read(filename)
        @filename = filename
      end

      def repin(gem, version)
        printf("Changing version pin of %<gem>s to %<version>s for %<binary>s\n",
               gem: gem,
               version: version,
               binary: @filename)

        @contents.gsub!(/(?<=#{gem}"), "= [.0-9]+"/, ", \"= #{version}\"")
      end

      def write_back
        File.write(@filename, @contents)
      end
    end # class Repin
  end # module RakeTasks
end # module Chef

ChefRake::Task::Repin.new
