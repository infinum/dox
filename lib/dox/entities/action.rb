module Dox
  module Entities
    class Action
      attr_reader :name, :desc, :verb, :path, :uri_params, :resource
      attr_accessor :examples

      def initialize(details, request)
        @request = request
        @name = details[:action_name]
        @resource = details[:resource_name]
        @desc = details[:action_desc]
        @verb = details[:action_verb] || request.method
        @path = details[:action_path] || template_path
        @uri_params = details[:action_params] || template_params
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

      def path_params
        @path_params ||=
          request.path_parameters.symbolize_keys.except(:action, :controller, :format, :subdomain)
      end

      def header_params
        request.filtered_parameters.symbolize_keys.except(:id, :action, :controller, :format, :subdomain)
      end

      def query_params
        return [] if request.env['RAW_POST_DATA'].nil?

        data = JSON.parse(request.env['RAW_POST_DATA'])['data']

        data['attributes'].symbolize_keys
      end

      def template_params
        all_params = []

        acquire_params(path_params, :path, all_params)
        acquire_params(header_params, :header, all_params)
        acquire_params(query_params, :query, all_params)

        all_params
      end

      def acquire_params(params, within, all_params)
        params.each do |param, value|
          param_type = guess_param_type(value)
          all_params.push(name: param, in: within, schema: { type: param_type })
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
