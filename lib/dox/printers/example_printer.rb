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
        example_request_body if example.request_body.present?
      end

      def add_example_response
        example_response_body if example.response_body.present?
      end

      def example_request_body
        request_body = existing_hash(@json_hash, 'request_body')
        request_body['content'] = add
      end

      def example_response_body
        @json_hash['summary'] = example.desc.capitalize
        responses = existing_hash(@json_hash, 'responses')
        status = existing_hash(responses, example.response_status.to_s)
        status['description'] = Util::Http::HTTP_STATUS_CODES[example.response_status]
        add_example
        status['content'] = add_example
      end

      def add_example
        { add_headers(example.response_headers) => { 'example' => JSON.parse(example.response_body) } }
      end

      def add_headers(headers)
        headers.map do |key, value|
          "#{key}: #{value}"
        end.join("\n")
      end
    end
  end
end
