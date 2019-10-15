require 'rexml/document'

module Dox
  module Printers
    class ExamplePrinter < BasePrinter
      def print(example)
        self.example = example
        @json_hash['summary'] = example.desc.capitalize
        add_example_request
        add_example_response
      end

      private

      attr_accessor :example

      def add_example_request
        request_body = existing_hash(@json_hash, 'requestBody')
        add_request_content_and_hash(request_body)
      end

      def add_request_content_and_hash(request_body)
        content_hash = existing_hash(request_body, 'content')
        request_body['content'] = content_hash

        req_header = add_request_headers(example.request_headers)

        header_hash = existing_hash(content_hash, req_header)
        content_hash[req_header] = header_hash

        unless example.request_body.empty?
          add_example_and_schema(example.request_body,
                                 header_hash,
                                 Dox.config.schema_request_folder_path)
        end
      end

      def add_example_response
        responses = existing_hash(@json_hash, 'responses')
        status = existing_hash(responses, example.response_status.to_s)
        add_statuses(status)
      end

      def add_statuses(status_hash)
        status_hash['description'] = Util::Http::HTTP_STATUS_CODES[example.response_status]
        add_response_content_and_hash(status_hash)
      end

      def add_response_content_and_hash(request_body)
        content_hash = existing_hash(request_body, 'content')
        request_body['content'] = content_hash

        resp_header = add_response_headers(example.response_headers)

        header_hash = existing_hash(content_hash, resp_header)
        content_hash[resp_header] = header_hash

        unless example.response_body.empty?
          add_example_and_schema(example.response_body, header_hash, Dox.config.schema_response_folder_path)
        end
      end

      def add_example_and_schema(body, header_hash, path)
        example_hash = existing_hash(header_hash, 'examples')
        header_hash['examples'] = example_hash
        example_hash[example.desc] = { 'summary' => example.desc, 'value' => JSON.parse(body)['data'] }
        return if example.schema.nil?

        header_hash['schema'] = { '$ref' => File.join(path, "#{example.schema}.json") }
      end

      def add_request_headers(headers)
        headers.map do |key, value|
          return value if key == 'Accept'
        end
      end

      def add_response_headers(headers)
        headers.map do |key, value|
          return value if key == 'Content-Type'
        end
      end
    end
  end
end
