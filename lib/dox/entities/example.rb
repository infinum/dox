module Dox
  module Entities
    class Example

      attr_reader :desc, :request, :response

      def initialize(details, request, response)
        @desc = details[:description]
        @request = request
        @response = response
      end

      def request_parameters
        request.parameters.except(*request.path_parameters.keys.map(&:to_s)).except(*request.query_parameters.keys.map(&:to_s))
      end

      def request_content_type
        request.content_type
      end

      def request_identifier
        @desc
      end

      def response_status
        response.status
      end

      def response_content_type
        response.content_type
      end

      def response_body
        response.body
      end

    end
  end
end
