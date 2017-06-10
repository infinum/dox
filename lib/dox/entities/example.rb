module Dox
  module Entities
    class Example
      extend Forwardable

      def_delegator :response, :status, :response_status
      def_delegator :response, :content_type, :response_content_type
      def_delegator :response, :body, :response_body
      def_delegator :request, :content_type, :request_content_type
      def_delegator :request, :method, :request_method

      def initialize(details, request, response)
        @desc = details[:description]
        @request = request
        @response = response
      end

      def request_body
        @request_body ||= parse_request_body
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

      # Rails 4 includes the body params in the request_fullpath
      def request_fullpath
        if request.query_parameters.present?
          "#{request_path}?#{request_url_query_parameters}"
        else
          request_path
        end
      end

      private

      # Rails 5.0.2 returns "" for request.path
      def request_path
        request.path.presence || request.fullpath.split("?")[0]
      end

      attr_reader :desc, :request, :response

      def filter_headers(obj)
        headers_whitelist.map do |header|
          header_val = obj.headers[header]
          next if header_val.blank?

          [header, header_val]
        end.compact
      end

      def headers_whitelist
        @headers_whitelist ||= Dox.full_headers_whitelist
      end

      def request_url_query_parameters
        CGI.unescape(request.query_parameters.to_query)
      end

      def parse_request_body
        body = request.body.read
        return body if body.to_s.empty?
        JSON.parse(body)
      end
    end
  end
end
