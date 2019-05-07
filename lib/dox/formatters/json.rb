module Dox
  module Formatters
    class Json < Dox::Formatters::Base
      def format
        JSON.pretty_generate(JSON.parse(body || ''))
      rescue JSON::ParserError
        ''
      end
    end
  end
end
