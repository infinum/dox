module Dox
  module Printers
    class ResourceGroupPrinter < BasePrinter

      def print(resource_group)
        @output.puts "\n# Group #{resource_group.name}\n\n#{print_desc(resource_group.desc)}\n"

        resource_group.resources.each do |_, resource|
          resource_printer.print(resource)
        end
      end

      private

      def resource_printer
        @resource_printer ||= ResourcePrinter.new(@output)
      end

    end
  end
end
