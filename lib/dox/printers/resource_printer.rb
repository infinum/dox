module Dox
  module Printers
    class ResourcePrinter < BasePrinter
      def print(resource)
        self.resource = resource
        @output.puts resource_title

        resource.actions.each do |_, action|
          action_printer.print(action)
        end
      end

      private

      attr_accessor :resource

      def resource_title
        <<-HEREDOC

## #{resource.name} [#{resource.endpoint}]
#{print_desc(resource.desc)}
        HEREDOC
      end

      def action_printer
        @action_printer ||= ActionPrinter.new(@output)
      end
    end
  end
end
