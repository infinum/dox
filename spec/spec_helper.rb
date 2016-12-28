require 'simplecov'
SimpleCov.start

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/json'
require 'active_support/core_ext/string'
require 'active_support/hash_with_indifferent_access'
require 'dox'
require 'pathname'
require 'pry'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

root_path = Pathname.new(File.expand_path('../', File.dirname(__FILE__)))
Dir[root_path.join('spec/support/**/*.rb')].each { |f| require f }
