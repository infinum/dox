require 'active_support'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/json'
require 'active_support/core_ext/string'
require 'active_support/hash_with_indifferent_access'
require 'codeclimate-test-reporter'
require 'dox'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

CodeClimate::TestReporter.start
