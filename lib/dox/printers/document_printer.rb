module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(body)
        @output = output
      end

      def print(passed_examples)
        spec['paths'] = {}
        spec['tags'] = []
        spec['x-tagGroups'] = []

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end

        @output.puts(JSON.pretty_generate(spec))
      end

      private

      def body
        {
          openapi: Dox.config.openapi_version || '3.0.0',
          info: {
            title: Dox.config.title || 'API Documentation',
            description: adjust_description(Dox.config.header_description || ''),
            version: Dox.config.api_version || '1.0'
          }
        }
      end

      def adjust_description(description)
        description.end_with?('.md') ? acquire_desc(description) : description
      end

      def acquire_desc(path)
        read_file(path)
      end

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(spec)
      end
    end
  end
end
