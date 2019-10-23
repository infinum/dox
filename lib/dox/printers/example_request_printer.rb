require 'rexml/document'

module Dox
  module Printers
    class ExampleRequestPrinter < BasePrinter
      def print(example)
        self.example = example
        add_example_request
      end

      private

      attr_accessor :example

      def add_example_request
        return if example.request_body.empty?

        add_content(find_or_add_hash(spec, 'requestBody'))
        spec['parameters'] = find_or_add_array(spec, 'parameters').push(*add_header_params).uniq
      end

      def add_content(body)
        add_header(body['content'] = find_or_add_hash(body, 'content'))
      end

      def add_header(body)
        req_header = find_headers(example.request_headers)
        add_example(body[req_header] = find_or_add_hash(body, req_header))
        add_schema(body[req_header], Dox.config.schema_request_folder_path)
      end

      def add_example(body)
        return if example.request_body.empty?

        add_desc(body['examples'] = find_or_add_hash(body, 'examples'))
      end

      def add_desc(body)
        body[example.desc] = { 'summary' => example.desc, 'value' => JSON.parse(example.request_body) }
      end

      def add_schema(body, path)
        return if example.request_schema.nil?

        body['schema'] = { '$ref' => File.join(path, "#{example.request_schema}.json") }
      end

      def find_headers(headers)
        headers.find { |key, _| key == 'Accept' }&.last || 'any'
      end

      def add_header_params
        example.request_headers.map do |key, value|
          { name: key, in: :header, example: value }
        end
      end
    end
  end
end
