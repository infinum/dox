module Dox
  module Printers
    class ResourcePrinter < BasePrinter

      def print(resource)
        @output.puts "\n## #{resource.name} [#{resource.endpoint}]\n\n#{print_desc(resource.desc)}\n"

        resource.actions.each do |_, action|
          action_printer.print(action)
        end
      end

      private

      def action_printer
        @action_printer ||= ActionPrinter.new(@output)
      end

    end
  end
end
