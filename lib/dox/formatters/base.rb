module Dox
  module Formatters
    class Base
      def initialize(dispatch)
        @dispatch = dispatch
        dispatch_body = dispatch.body
        @body = dispatch_body.respond_to?(:read) ? dispatch_body.read : dispatch_body
      end

      def format
        raise 'no format method defined in formatter'
      end

      private

      attr_reader :dispatch, :body
    end
  end
end
