module Dox
  module Printers
    class ResourceGroupPrinter < BasePrinter
      def print(resource_group)
        self.resource_group = resource_group
        add_resource_group_to_spec

        resource_group.resources.each do |_, resource|
          resource_printer.print(resource)
        end
      end

      private

      attr_accessor :resource_group

      def add_resource_group_to_spec
        spec['x-tagGroups'].push(name: resource_group.name, 'tags' => []) unless find_group(spec['x-tagGroups'])
      end

      def find_group(group_array)
        group_array.find { |group| group[:name] == resource_group.name }
      end

      def resource_printer
        @resource_printer ||= ResourcePrinter.new(spec)
      end
    end
  end
end
