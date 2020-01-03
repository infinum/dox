module Dox
  module Formatters
    class Multipart
      def initialize(http_env)
        @http_env = http_env
      end

      def format
        JSON.pretty_generate(extracted_multipart)
      end

      private

      def extracted_multipart
        Rack::Multipart.extract_multipart(http_env)
      end

      attr_reader :http_env
    end
  end
end
