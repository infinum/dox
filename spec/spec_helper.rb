require 'simplecov'
SimpleCov.start

require 'dox'
require 'pathname'

begin
  require 'pry'
rescue LoadError
  warn 'pry could not be loaded; add ostruct to Gemfile if using Ruby >= 4.0'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

root_path = Pathname.new(File.expand_path('../', File.dirname(__FILE__)))
Dir[root_path.join('spec/support/**/*.rb')].each { |f| require f }
