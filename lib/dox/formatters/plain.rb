module Dox
  module Formatters
    class Plain < Dox::Formatters::Base
      def format
        normalize(body)
      end

      private

      def normalize(data)
        case data
        when String
          to_utf8(data)
        else
          data
        end
      end

      def to_utf8(stream)
        return stream if stream.encoding == Encoding::UTF_8

        stream.encode(Encoding::UTF_8)
      rescue Encoding::UndefinedConversionError
        "#{stream.encoding} stream"
      end
    end
  end
end
