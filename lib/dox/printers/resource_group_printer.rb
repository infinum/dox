module Dox
  module Printers
    class ResourceGroupPrinter < BasePrinter
      def print(resource_group)
        self.resource_group = resource_group
        add_resource_group

        resource_group.resources.each do |_, resource|
          resource_printer.print(resource)
        end
      end

      private

      attr_accessor :resource_group

      def add_resource_group
        spec['x-tagGroups'].push(name: resource_group.name, 'tags' => []) unless group_included?
      end

      def group_included?
        spec['x-tagGroups'].find { |group| group[:name] == resource_group.name }
      end

      def resource_printer
        @resource_printer ||= ResourcePrinter.new(spec)
      end
    end
  end
end
