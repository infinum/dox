require 'rspec/core'
require 'rspec/core/formatters/base_formatter'
require 'rspec/core/formatters/console_codes'
require 'forwardable'

module Dox
  class Formatter < RSpec::Core::Formatters::BaseFormatter
    extend Forwardable

    RSpec::Core::Formatters.register self, :example_passed, :stop, :dump_summary

    def initialize(output)
      super
      self.passed_examples = {}
    end

    def example_passed(passed)
      self.current_example = CurrentExample.new(passed.example)
      move_example_to_passed if current_example.document?
    end

    def stop(notification)
      if notification.failed_examples.any?
        $stderr.puts(notification.fully_formatted_failed_examples)
      else
        printer.print(passed_examples)
      end
    end

    def dump_summary(summary)
      return if summary.failed_examples.none?
      $stderr.puts(summary.fully_formatted)
      exit(-1)
    end

    private

    attr_accessor :passed_examples
    attr_accessor :current_example

    def load_or_save_group
      group_name = current_example.resource_group_name
      group = passed_examples[group_name]

      if group
        group.tap { |g| g.desc ||= current_example.resource_group_desc }
      else
        passed_examples[group_name] = Entities::ResourceGroup.new(group_name,
                                                                  current_example.metadata)
      end
    end

    def load_or_save_resource_to_group(group)
      resource_name = current_example.resource_name
      group.resources[resource_name] ||= Entities::Resource.new(resource_name,
                                                                current_example.metadata)
    end

    def load_or_save_action_to_resource(resource)
      action_name = current_example.action_name
      resource.actions[action_name] ||= Entities::Action.new(action_name, current_example.metadata,
                                                             current_example.request)
    end

    def move_example_to_passed
      group = load_or_save_group
      resource = load_or_save_resource_to_group(group)
      action = load_or_save_action_to_resource(resource)
      action.examples << Entities::Example.new(current_example.metadata, current_example.request, current_example.response)
    end

    def printer
      @printer ||= Printers::DocumentPrinter.new(output)
    end

    class CurrentExample # :nodoc:
      extend Forwardable

      delegate [:metadata] => :example

      attr_reader :example

      def initialize(example)
        @example = example
      end

      def resource_group_name
        metadata[:resource_group_name]
      end

      def resource_group_desc
        metadata[:resource_group_desc]
      end

      def resource_name
        metadata[:resource_name]
      end

      def action_name
        metadata[:action_name]
      end

      def request
        metadata[:request]
      end

      def response
        metadata[:response]
      end

      def document?
        tagged_with?(:apidoc) && tagged_with?(:dox) && !tagged_with?(:nodoc)
      end

      private

      def tagged_with?(key)
        metadata.key?(key) && metadata[key] == true
      end
    end
  end
end
