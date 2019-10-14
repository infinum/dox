module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(acquire_header(api_info_path))
        @output = output
      end

      def print(passed_examples)
        @json_hash['paths'] = {}
        @json_hash['tags'] = []
        @json_hash['x-tagGroups'] = []

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end

        @output.puts(JSON.pretty_generate(@json_hash))
      end

      private

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(@json_hash)
      end

      def api_info_path
        Dox.config.header_file_path
      end
    end
  end
end
