lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef/raketasks/version'

Gem::Specification.new do |spec|
  spec.name           = 'chef-raketasks'
  spec.version        = ChefRake::Task::VERSION
  spec.licenses       = ['Apache-2.0']
  spec.authors        = ['Patrick Schaumburg', 'Thomas Heinen']
  spec.email          = ['pschaumburg@tecracer.de', 'theinen@tecracer.de']

  spec.summary        = 'Collection of reusable Rake tasks for Chef'
  spec.description    = 'Provides a central repository of the most essential tasks'
  spec.homepage       = 'https://www.tecracer.de'

  spec.metadata       = { 'rubygems_mfa_required' => 'true' }

  spec.files           = Dir['lib/**/**/**']
  spec.files          += ['README.md', 'CHANGELOG.md']

  spec.required_ruby_version = '>= 2.5'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'mdl', '~> 0.4'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.18'

  spec.add_dependency 'berkshelf', '~> 7.0'
  spec.add_dependency 'parse_gemspec', '~> 1.0'
  spec.add_dependency 'rake', '~> 13.0'
  spec.add_dependency 'rspec', '~> 3.9'
  spec.add_dependency 'rubocop', '~> 1.1'
  spec.add_dependency 'yard', '~> 0.9'

  spec.post_install_message = 'Add `require \'chef-raketasks\'` to your `Rakefile`.'
end
