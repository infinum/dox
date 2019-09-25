module Dox
  module Printers
    class ResourcePrinter < BasePrinter
      def print(resource)
        self.resource = resource

        resource.actions.each do |_, action|
          action_printer.print(action)
        end
      end

      private

      attr_accessor :resource

      def action_printer
        @action_printer ||= ActionPrinter.new(@json_hash)
      end
    end
  end
end
