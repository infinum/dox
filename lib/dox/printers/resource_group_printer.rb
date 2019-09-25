module Dox
  module Printers
    class ResourceGroupPrinter < BasePrinter
      def print(resource_group)
        self.resource_group = resource_group
        # add_resource_group

        resource_group.resources.each do |_, resource|
          resource_printer.print(resource)
        end
      end

      private

      attr_accessor :resource_group

      def add_resource_group
        @next_hash = {}
      end

      def resource_printer
        @resource_printer ||= ResourcePrinter.new(@json_hash)
      end
    end
  end
end
