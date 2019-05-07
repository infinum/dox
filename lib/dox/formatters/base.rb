module Dox
  module Formatters
    class Base
      def initialize(http_env)
        @http_env = http_env
        http_env_body = http_env.body
        @body = http_env_body.respond_to?(:read) ? http_env_body.read : http_env_body
      end

      def format
        raise 'no format method defined in formatter'
      end

      private

      attr_reader :http_env, :body
    end
  end
end
