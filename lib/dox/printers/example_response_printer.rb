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
        add_statuses(find_or_add(find_or_add(spec, 'responses'), example.response_status.to_s))
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
        add_content_name(body['content'] = find_or_add(body, 'content'))
      end

      def add_content_name(body)
        resp_header = find_headers(example.response_headers)

        add_example(body[resp_header] = find_or_add(body, resp_header))
        add_schema(body[resp_header], Dox.config.schema_response_folder_path)
      end

      def add_example(body)
        return if example.response_body.empty?

        add_desc(body['examples'] = find_or_add(body, 'examples'))
      end

      def add_desc(body)
        body[example.desc] = { 'summary' => example.desc,
                               'value' => formatted_body(example.response_body,
                                                         find_headers(example.response_headers)) }
      end

      def add_schema(body, path)
        schema = example.response_schema_success

        if example.response_status.to_s.start_with?('4')
          schema = example.response_schema_fail

          if schema.nil?
            add_default_schema(body)
            schema = nil
          end
        end

        return if schema.nil?

        body['schema'] = { '$ref' => File.join(path, "#{schema}.json") }
      end

      def add_default_schema(body)
        body['schema'] = { '$ref' => Dox.config.schema_response_fail_file_path }
      end

      def find_headers(headers)
        headers.find { |key, _| key == 'Content-Type' }&.last || 'any'
      end

      def add_headers(body)
        body['headers'] = Hash[example.response_headers.map { |key, value| [key, { description: value }] }]
      end
    end
  end
end
