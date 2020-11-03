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
    class Doc < ::Rake::TaskLib
      def initialize
        super

        desc 'Generate Ruby documentation'
        task :doc do
          require 'yaml'
          require 'yard'
          YARD::Rake::YardocTask.new do |t|
            t.stats_options = %w[--list-undoc]
          end
        end

      end # def initialize
    end # class Doc
  end # module RakeTasks
end # module Chef

ChefRake::Task::Doc.new
