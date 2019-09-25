module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(acquire_desc(api_desc_path))
        @output = output
      end

      def print(passed_examples)
        @next_hash = {}
        @json_hash['paths'] = @next_hash

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end

        @output.puts(JSON.pretty_generate(@json_hash))
      end

      private

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(@next_hash)
      end

      def api_desc_path
        Dox.config.header_file_path
      end
    end
  end
end
