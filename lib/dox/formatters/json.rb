module Dox
  module Formatters
    class Json < Dox::Formatters::Base
      def format
        return '' if body.nil? || body.length < 2

        JSON.pretty_generate(JSON.parse(body))
      end
    end
  end
end
