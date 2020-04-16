#
# Author:: Patrick Schaumburg (<pschaumburg@tecracer.de>)
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
