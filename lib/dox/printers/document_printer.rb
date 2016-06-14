module Dox
  module Printers
    class DocumentPrinter < BasePrinter

      def print(passed_examples)
        print_meta_info

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end
      end

      private

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(@output)
      end

      def print_meta_info
        @output.puts(print_desc(api_desc_path))
      end

      def api_desc_path
        Dox.config.root_api_file
      end

    end
  end
end
