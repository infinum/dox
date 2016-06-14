require 'rspec/core/formatters/base_formatter'
require 'pry'

module Dox
  class Formatter < RSpec::Core::Formatters::BaseFormatter

    RSpec::Core::Formatters.register self, :example_passed, :example_started, :stop

    def initialize(output)
      super
      @passed_examples = {}
      @group_level = 0
    end

    def example_started(notification)
      @example_group_instance = notification.example.example_group_instance
    end

    def example_passed(passed)
      @current_example_data = passed.example.metadata
      if should_document_example?
        move_example_to_passed
      end
      @example_group_instance = nil
    end

    def stop(_notification)
      printer.print(@passed_examples)
    end

    private

    def load_or_save_group
      group_name = @current_example_data[:resource_group_name]
      group = @passed_examples[group_name]

      if group
        group.desc ||= @current_example_data[:resource_group_desc]
        group
      else
        @passed_examples[group_name] = Entities::ResourceGroup.new(group_name, @current_example_data)
      end
    end

    def load_or_save_resource_to_group(group)
      resource_name = @current_example_data[:resource_name]
      group.resources[resource_name] ||= Entities::Resource.new(resource_name, @current_example_data)
    end

    def load_or_save_action_to_resource(resource)
      action_name = @current_example_data[:action_name]
      resource.actions[action_name] ||= Entities::Action.new(action_name, @current_example_data)
    end

    def move_example_to_passed
      group = load_or_save_group
      resource = load_or_save_resource_to_group(group)
      action = load_or_save_action_to_resource(resource)
      action.examples << Entities::Example.new(@current_example_data, request, response)
    end

    def should_document_example?
      @current_example_data[:apidoc] &&
        !@current_example_data[:nodoc]
      # error check
      #&&
        # @current_example_data[:resource_group] &&
        # @current_example_data[:resource] &&
        # @current_example_data[:action] &&
        # !@current_example_data[:nodoc]
    end

    def request
      @example_group_instance.request
    end

    def response
      @example_group_instance.response
    end

    def printer
      @printer ||= Printers::DocumentPrinter.new(output)
    end

  end
end
