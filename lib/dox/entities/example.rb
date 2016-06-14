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
        fullpath
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

      private

      def path
        request.path.sub(/\.json[^\?]*/, '')
      end

      def fullpath
        if request.query_parameters.present?
          URI::HTTP.build(path: path, query: request.query_parameters.to_query)
        else
          path
        end
      end
    end
  end
end
