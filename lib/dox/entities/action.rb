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
        acquire_path_params + acquire_defined_params(defined_params)
      end

      def path_params
        request.path_parameters.symbolize_keys.except(:action, :controller, :format, :subdomain)
      end

      def acquire_path_params
        return [] if path_params.nil?

        path_params.map do |param, value|
          { name: param,
            in: :path,
            schema: { type: guess_param_type(value) },
            example: value }
        end
      end

      def acquire_defined_params(defined_params)
        return [] if defined_params.nil?

        defined_params.map do |key, value|
          { name: key,
            in: 'query',
            required: value[:required],
            example: value[:value],
            type: value[:type],
            description: value[:description],
            schema: resolve_schema(value[:schema]) }
        end
      end

      def resolve_schema(schema)
        return if schema.nil?

        {}.tap do |property|
          add_basic_attributes(schema, property)

          next unless schema[:properties]

          property[:properties] = next_property = {}
          schema[:properties].each do |name, next_scheme|
            next_property[name] = resolve_schema(next_scheme)
          end
        end
      end

      def add_basic_attributes(from, to)
        to[:type] = from[:type]
        to[:required] = from[:required]
        to[:description] = from[:description]
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
