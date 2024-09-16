module Dox
  module Entities
    class Example
      extend Forwardable

      attr_reader :desc, :name, :request_schema, :response_schema_success, :response_schema_fail

      def_delegator :request, :method, :request_method
      def_delegator :response, :status, :response_status

      def initialize(details, request, response)
        @desc = details[:description]
        @name = details[:resource_name].downcase
        @request_schema = details[:action_request_schema]
        @response_schema_success = details[:action_response_schema_success]
        @response_schema_fail = details[:action_response_schema_fail]
        @request = request
        @response = response
      end

      def request_body
        @request_body ||= format_content(request, request_content_type)
      end

      def response_body
        @response_body ||= format_content(response, response_content_type)
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

      def response_success?
        response.successful?
      end

      # Rails 4 includes the body params in the request_fullpath
      def request_fullpath
        if request.query_parameters.present?
          "#{request_path}?#{request_url_query_parameters}"
        else
          request_path
        end
      end

      # Rails 7 changes content_type result
      def request_content_type
        request.respond_to?(:media_type) ? request.media_type : request.content_type
      end

      def response_content_type
        response.respond_to?(:media_type) ? response.media_type : response.content_type
      end

      private

      def format_content(http_env, content_type)
        formatter(content_type).new(http_env).format
      end

      def formatter(content_type)
        case content_type
        when %r{application\/.*json}
          Dox::Formatters::Json
        when /xml/
          Dox::Formatters::Xml
        when /multipart/
          Dox::Formatters::Multipart
        else
          Dox::Formatters::Plain
        end
      end

      # Rails 5.0.2 returns "" for request.path
      def request_path
        request.path.presence || request.fullpath.split('?')[0]
      end

      attr_reader :request, :response

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
    end
  end
end
