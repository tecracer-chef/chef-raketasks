Dir['./spec/support/**/*.rb'].reverse_each { |file| require file }
Dir['./lib/**/*.rb'].reverse_each { |file| require file }

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = 'random'
  config.default_formatter = 'doc'
end
