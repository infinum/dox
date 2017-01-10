require 'forwardable'

module Dox
  module Entities
    class Example
      extend Forwardable

      def_delegator :response, :status, :response_status
      def_delegator :response, :content_type, :response_content_type
      def_delegator :response, :body, :response_body
      def_delegator :request, :content_type, :request_content_type

      def initialize(details, request, response)
        @desc = details[:description]
        @request = request
        @response = response
      end

      def request_parameters
        request.parameters
               .except(*request.path_parameters.keys.map(&:to_s))
               .except(*request.query_parameters.keys.map(&:to_s))
      end

      def request_identifier
        @desc
      end

      def response_headers
        @response_headers ||= filter_headers(response)
      end

      def request_headers
        @request_headers ||= filter_headers(request)
      end

      private

      attr_reader :desc, :request, :response

      def filter_headers(obj)
        obj.headers.find_all do |key, _|
          headers_whitelist.include?(key)
        end
      end

      def headers_whitelist
        @headers_whitelist ||= Dox.full_headers_whitelist
      end
    end
  end
end
