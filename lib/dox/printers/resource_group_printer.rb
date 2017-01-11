module Dox
  module Printers
    class ResourceGroupPrinter < BasePrinter
      def print(resource_group)
        self.resource_group = resource_group
        @output.puts resource_group_title

        resource_group.resources.each do |_, resource|
          resource_printer.print(resource)
        end
      end

      private

      attr_accessor :resource_group

      def resource_group_title
        <<-HEREDOC

# Group #{resource_group.name}
#{print_desc(resource_group.desc)}
        HEREDOC
      end

      def resource_printer
        @resource_printer ||= ResourcePrinter.new(@output)
      end
    end
  end
end
