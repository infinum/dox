module Dox
  module Printers
    class ActionPrinter < BasePrinter
      def print(action)
        self.action = action
        add_action
        add_action_uri_params if action.uri_params.present?

        action.examples.each do |example|
          example_printer.print(example)
        end
      end

      private

      attr_accessor :action

      def add_action
        @path_hash = existing_hash(@json_hash, action.path.to_s)

        @next_hash = existing_hash(@path_hash, action.verb.downcase.to_s)
      end

      def add_action_uri_params
        @next_hash['parameters'] = action.uri_params
      end

      def example_printer
        @example_printer = ExamplePrinter.new(@next_hash)
      end
    end
  end
end
