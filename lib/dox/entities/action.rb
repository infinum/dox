module Dox
  module Entities
    class Action
      using Dox::Utils::RefinedHash

      attr_reader :name, :desc, :verb, :path, :uri_params
      attr_accessor :examples

      def initialize(name, details, request)
        @request = request
        @name = name
        @desc = details[:action_desc]
        @verb = details[:action_verb] || request.method
        @path = details[:action_path] || template_path
        @uri_params = details[:action_params] || template_path_params
        @examples = []
      end

      private

      attr_reader :request

      # /pokemons/1 => pokemons/{id}
      def template_path
        path = request.path.dup
        path_params.each do |key, value|
          path.sub!(%r{\/#{value}(\/|$)}, "/{#{key}}\\1")
        end
        path
      end

      def path_params
        @path_params ||= request.path_parameters.symbolize_keys.except(:action, :controller, :format)
      end

      def template_path_params
        h = {}
        path_params.each do |param, value|
          param_type = guess_param_type(value)
          h[param] = { type: param_type, required: :required, value: value }
        end
        h
      end

      def guess_param_type(param)
        if param =~ /^\d+$/
          :number
        else
          :string
        end
      end
    end
  end
end
