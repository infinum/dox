require 'rexml/document'

module Dox
  module Printers
    class ExamplePrinter < BasePrinter
      def print(example)
        self.example = example
        add_example_request
        add_example_response
      end

      private

      attr_accessor :example

      def add_example_request
        return if example.request_body.empty?

        request_body = existing_hash(@json_hash, 'requestBody')
        add_request_content_and_hash(request_body)
        add_header_params(existing_array(@json_hash, 'parameters'), example.request_headers)
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
                                 Dox.config.schema_request_folder_path,
                                 example.request_schema)
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
        add_headers(status_hash, example.response_headers)
      end

      def add_response_content_and_hash(request_body)
        content_hash = existing_hash(request_body, 'content')
        request_body['content'] = content_hash

        resp_header = add_response_headers(example.response_headers)

        header_hash = existing_hash(content_hash, resp_header)
        content_hash[resp_header] = header_hash

        unless example.response_body.empty?
          add_example_and_schema(example.response_body,
                                 header_hash,
                                 Dox.config.schema_response_folder_path,
                                 schema_type)
        end
      end

      def schema_type
        example.response_status.to_s.start_with?('2') ? example.response_schema_success : example.response_schema_fail
      end

      def add_example_and_schema(body, header_hash, path, schema)
        example_hash = existing_hash(header_hash, 'examples')
        header_hash['examples'] = example_hash
        example_hash[example.desc] = { 'summary' => example.desc, 'value' => JSON.parse(body) }
        return if schema.nil?

        header_hash['schema'] = { '$ref' => File.join(path, "#{schema}.json") }
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

      def add_header_params(body, raw_headers)
        raw_headers.map do |key, value|
          next if body.any? { |h| h[:name] == key }

          body.push(name: key, in: :header, example: value)
        end
      end

      def add_headers(body, raw_headers)
        hash = {}
        body['headers'] = hash

        raw_headers.map do |key, value|
          hash[key] = { description: value }
        end
      end
    end
  end
end
