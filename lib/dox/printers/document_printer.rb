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

        order_groups

        @output.puts(JSON.pretty_generate(spec))
      end

      private

      def body
        {
          openapi: Dox.config.openapi_version || '3.0.0',
          info: {
            title: Dox.config.title || 'API Documentation',
            description: adjusted_description,
            version: Dox.config.api_version || '1.0'
          }
        }
      end

      def adjusted_description
        format_desc(Dox.config.header_description)
      end

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(spec)
      end

      def order_groups
        return if (Dox.config.groups_order || []).empty?

        spec['x-tagGroups'] = spec['x-tagGroups'].sort_by do |tag|
          Dox.config.groups_order.index(tag[:name]) || 100
        end
      end
    end
  end
end
