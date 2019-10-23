require 'rexml/document'

module Dox
  module Printers
    class ExampleResponsePrinter < BasePrinter
      def print(example)
        self.example = example
        add_example_response
      end

      private

      attr_accessor :example

      def add_example_response
        add_statuses(find_or_add_hash(find_or_add_hash(spec, 'responses'), example.response_status.to_s))
      end

      def add_statuses(body)
        add_status_desc(body)
        add_content(body)
        add_headers(body)
      end

      def add_status_desc(body)
        body['description'] = Util::Http::HTTP_STATUS_CODES[example.response_status]
      end

      def add_content(body)
        add_header(body['content'] = find_or_add_hash(body, 'content'))
      end

      def add_header(body)
        resp_header = find_response_headers(example.response_headers)

        add_example(body[resp_header] = find_or_add_hash(body, resp_header))
        add_schema(body[resp_header], Dox.config.schema_response_folder_path, schema_type)
      end

      def schema_type
        example.response_status.to_s.start_with?('2') ? example.response_schema_success : example.response_schema_fail
      end

      def add_example(body)
        return if example.response_body.empty?

        add_desc(body['examples'] = find_or_add_hash(body, 'examples'))
      end

      def add_desc(body)
        body[example.desc] = { 'summary' => example.desc, 'value' => JSON.parse(example.response_body) }
      end

      def add_schema(body, path, schema)
        return if schema.nil?

        body['schema'] = { '$ref' => File.join(path, "#{schema}.json") }
      end

      def find_response_headers(headers)
        headers.find { |key, _| key == 'Content-Type' }&.last || 'any'
      end

      def add_headers(body)
        body['headers'] = Hash[example.response_headers.map { |key, value| [key, { description: value }] }]
      end
    end
  end
end
