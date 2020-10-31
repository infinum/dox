module Dox
  module Formatters
    class Plain < Dox::Formatters::Base
      def format
        return body if body.encoding == Encoding::UTF_8

        body.encode(Encoding::UTF_8)
      rescue Encoding::UndefinedConversionError
        "#{body.encoding} stream"
      end
    end
  end
end
