require 'dox/config'
require 'dox/dsl/attr_proxy'
require 'dox/dsl/action'
require 'dox/dsl/documentation'
require 'dox/dsl/resource_group'
require 'dox/dsl/resource'
require 'dox/dsl/syntax'
require 'dox/entities/action'
require 'dox/entities/example'
require 'dox/entities/resource_group'
require 'dox/entities/resource'
require 'dox/errors/file_not_found_error'
require 'dox/errors/folder_not_found_error'
require 'dox/errors/invalid_action_error'
require 'dox/errors/invalid_resource_error'
require 'dox/errors/invalid_resource_group_error'
require 'dox/formatter'
require 'dox/printers/base_printer'
require 'dox/printers/action_printer'
require 'dox/printers/document_printer'
require 'dox/printers/example_printer'
require 'dox/printers/resource_group_printer'
require 'dox/printers/resource_printer'
require 'dox/util/http'
require 'dox/version'

module Dox
  Error = Class.new(StandardError)

  def self.configure
    yield(config) if block_given?
  end

  def self.config
    @config ||= Dox::Config.new
  end

  DEFAULT_HEADERS_WHITELIST = ['Accept', 'Content-Type'].freeze
  def self.full_headers_whitelist
    config.headers_whitelist.to_a + DEFAULT_HEADERS_WHITELIST
  end
end
