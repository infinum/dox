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
        spec['parameters'] = add_new_header_params(find_or_add(spec, 'parameters', []))
        return if example.request_body.empty?

        add_content(find_or_add(spec, 'requestBody'))
      end

      def add_content(body)
        add_content_name(body['content'] = find_or_add(body, 'content'))
      end

      def add_content_name(body)
        req_header = find_headers(example.request_headers)
        add_example(body[req_header] = find_or_add(body, req_header))
        add_schema(body[req_header], Dox.config.schema_request_folder_path)
      end

      def add_example(body)
        add_desc(body['examples'] = find_or_add(body, 'examples'))
      end

      def add_desc(body)
        body[example.desc] = { 'summary' => example.desc,
                               'value' => formatted_body(example.request_body,
                                                         find_headers(example.request_headers)) }
      end

      def add_schema(body, path)
        return if example.request_schema.nil?

        file_path = File.join(path, "#{example.request_schema}.json")

        body['schema'] = File.file?(file_path) ? { '$ref' => file_path } : JSON.parse(example.request_schema)
      end

      def find_headers(headers)
        headers.find { |key, _| key == 'Accept' }&.last || 'any'
      end

      def acquire_header_params
        example.request_headers.map do |key, value|
          { name: key, in: :header, example: value }
        end
      end

      def add_new_header_params(header_params)
        example.request_headers.each do |key, value|
          header_params.push(name: key, in: :header, example: value) unless
            header_params.detect { |hash| hash[:name] == key }
        end

        header_params
      end
    end
  end
end
