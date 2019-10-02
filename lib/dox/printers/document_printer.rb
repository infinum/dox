module Dox
  module Printers
    class DocumentPrinter < BasePrinter
      def initialize(output)
        super(acquire_desc(api_desc_path))
        @output = output
      end

      def print(passed_examples)
        @json_hash['paths'] = {}
        @json_hash['components'] = add_components
        @json_hash['tags'] = []
        @json_hash['x-tagGroups'] = []

        passed_examples.sort.each do |_, resource_group|
          group_printer.print(resource_group)
        end

        @output.puts(JSON.pretty_generate(@json_hash))
      end

      private

      def add_components
        component_hash = {}

        component_hash['schemas'] = add_schemas

        component_hash
      end

      def add_schemas
        schemas = Dir[File.join(Dox.config.schema_folder_path, '/**/*.json')]
        schema_hash = {}

        schemas.each do |schema|
          next if schema.end_with?('output.json')

          name = schema.match(%r{.*/(.*).json})[1]

          schema_hash[name] = JSON.parse(File.read(schema))
        end

        schema_hash
      end

      def group_printer
        @group_printer ||= ResourceGroupPrinter.new(@json_hash)
      end

      def api_desc_path
        Dox.config.header_file_path
      end
    end
  end
end
