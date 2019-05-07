module Dox
  module Formatters
    class Json < Dox::Formatters::Base
      def format
        # in cases where the body isn't valid JSON
        # and the headers specify the Content-Type is application/json
        # an error should be raised
        return '' if body.nil? || body.length < 2

        JSON.pretty_generate(JSON.parse(body))
      end
    end
  end
end
