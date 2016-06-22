module Dox
  module Entities
    class Action

      attr_accessor :name, :desc, :verb, :path, :uri_params, :examples

      def initialize(name, details, request)
        @request = request
        @name = name
        @desc = details[:action_desc]
        @verb = details[:action_verb] || request.method
        @path = details[:action_path] || template_path
        @uri_params = details[:action_params]
        @examples = []
      end

      private

      attr_reader :request

      def template_path
        path_params = request.path_parameters.except(:action, :controller)
        path = request.path
        path_params.each do |key, value|
          path.sub!(value, "{#{key}}")
        end
        path
      end

    end
  end
end
