module Dox
  module Entities
    class Action
      attr_reader :name, :desc, :verb, :path, :resource, :params
      attr_accessor :examples

      def initialize(details, request)
        @request = request
        @name = details[:action_name]
        @resource = details[:resource_name]
        @desc = details[:action_desc]
        @verb = details[:action_verb] || request.method
        @path = details[:action_path] || template_path
        @params = template_params(details[:action_params])
        @examples = []

        validate!
      end

      private

      attr_reader :request

      # /pokemons/1 => pokemons/{id}
      def template_path
        path = request.path.dup.presence || request.fullpath.split('?').first
        path_params.each do |key, value|
          path.sub!(%r{\/#{value}(\/|$)}, "/{#{key}}\\1")
        end

        path
      end

      def template_params(defined_params)
        acquire_path_params(path_params) + acquire_defined_params(defined_params)
      end

      def path_params
        request.path_parameters.symbolize_keys.except(:action, :controller, :format, :subdomain)
      end

      def acquire_path_params(path_params)
        return [] if path_params.nil?

        path_params.map do |param, value|
          { name: param,
            in: :path,
            schema: { type: guess_param_type(value) } }
        end
      end

      def acquire_defined_params(defined_params)
        return [] if defined_params.nil?

        defined_params.map do |key, value|
          { name: key,
            in: 'query',
            required: value[:required],
            description: value[:description],
            schema: { type: value[:type] } }
        end
      end

      def guess_param_type(param)
        if param =~ /^\d+$/
          :number
        else
          :string
        end
      end

      def validate!
        raise(Error, "Unrecognized HTTP verb #{verb}") unless Util::Http.verb?(verb)
      end
    end
  end
end
