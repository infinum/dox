module Dox
  module Formatters
    class Plain < Dox::Formatters::Base
      def format
        body
      end
    end
  end
end
