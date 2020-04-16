#
# Chef Raketasks definition and includes
#

require 'rake'
require 'rake/tasklib'

require_relative 'chef/raketasks/clean'
require_relative 'chef/raketasks/doc'
require_relative 'chef/raketasks/gem'
require_relative 'chef/raketasks/package'
require_relative 'chef/raketasks/release'
require_relative 'chef/raketasks/test'
require_relative 'chef/raketasks/version'

# Hide tasks which are rescoped or not needed usually
%w[
  doc
  gem:install:generator
  gem:install:generator:appinstall
  package:policyfile:pack
  package:policyfile:update
  test:integration
  test:unit:cookbook
].each do |task|
  Rake::Task[task].clear_comments if Rake::Task.task_defined? task
end
