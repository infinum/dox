module Dox
  module Formatters
    class Multipart
      def initialize(dispatch)
        @dispatch = dispatch
      end

      def format
        JSON.pretty_generate(extracted_multipart)
      end

      private

      def extracted_multipart
        Rack::Multipart.extract_multipart(dispatch)
      end

      attr_reader :dispatch
    end
  end
end
