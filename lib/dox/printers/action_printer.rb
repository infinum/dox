module Dox
  module Printers
    class ActionPrinter < BasePrinter
      def print(action)
        self.action = action
        @action_hash = find_or_add_hash(find_or_add_hash(spec, action.path.to_s), action.verb.downcase.to_sym)

        add_action
        add_action_params

        action.examples.each do |example|
          example_request_printer.print(example)
          example_response_printer.print(example)
        end
      end

      private

      attr_accessor :action, :action_hash

      def add_action
        action_hash['summary'] = action.name
        action_hash['tags'] = [action.resource]
      end

      def add_action_params
        return unless action.params.present?

        action_hash['parameters'] = action.params
      end

      def example_request_printer
        @example_request_printer = ExampleRequestPrinter.new(@action_hash)
      end

      def example_response_printer
        @example_response_printer = ExampleResponsePrinter.new(@action_hash)
      end
    end
  end
end
