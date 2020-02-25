module Dox
  module Printers
    class ActionPrinter < BasePrinter
      def print(action)
        self.action = action
        @action_hash = find_or_add(find_or_add(spec, action.path.to_s), action.verb.downcase.to_sym)

        add_action
        add_action_params

        print_examples
      end

      private

      attr_accessor :action, :action_hash

      def add_action
        action_hash['summary'] = action.name
        action_hash['tags'] = [action.resource]
        action_hash['description'] = action.desc
      end

      def add_action_params
        return unless action.params.present?

        action_hash['parameters'] = action.params
      end

      def print_examples
        action.examples.each do |example|
          ExampleRequestPrinter.new(action_hash).print(example)
          ExampleResponsePrinter.new(action_hash).print(example)
        end
      end
    end
  end
end
