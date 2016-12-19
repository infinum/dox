module Dox
  module Util
    module Http
      VERB = ['POST', 'GET', 'PUT', 'PATCH', 'DELETE', 'HEAD'].freeze

      def self.verb?(value)
        VERB.include?(value.upcase)
      end
    end
  end
end
