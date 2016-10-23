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
        @uri_params = details[:action_params]
        @examples = []
      end

      private

      attr_reader :request

      def template_path
        path_params = request.path_parameters.symbolize_keys.except(:action, :controller)
        path = request.path.dup
        path_params.each do |key, value|
          # /pokemons/1 => pokemons/{id}
          path.sub!(/\/#{value}(\/|$)/, "/{#{key}}\\1")
        end
        path
      end


    end
  end
end
