#
# ChefRake::Task::Doc
# Add tasks for creation of docs with yard
#

module ChefRake
  module Task
    include Rake::DSL if defined? Rake::DSL
    class Doc < ::Rake::TaskLib
      def initialize

        desc 'Generate Ruby documentation'
        task :doc do
          require 'yaml'
          require 'yard'
          YARD::Rake::YardocTask.new do |t|
            t.stats_options = %w(--list-undoc)
          end
        end

      end # def initialize
    end # class Doc
  end # module RakeTasks
end # module Chef

ChefRake::Task::Doc.new
