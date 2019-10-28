module Dox
  module DSL
    class Action
      include AttrProxy

      attr_writer :name
      attr_writer :verb
      attr_writer :path
      attr_writer :desc
      attr_writer :params
      attr_writer :request_schema
      attr_writer :response_schema_success
      attr_writer :response_schema_fail

      def initialize(name, &block)
        self.name = name
        instance_eval(&block) if block_given?

        raise(Dox::Errors::InvalidActionError, 'Action name is required!') if @name.blank?
      end

      def config
        {
          action_request_schema: @request_schema.presence,
          action_response_schema_success: @response_schema_success.presence,
          action_response_schema_fail: @response_schema_fail.presence || default_fail,
          action_name: @name.presence,
          action_verb: @verb.presence,
          action_path: @path.presence,
          action_desc: @desc.presence,
          action_params: @params.presence
        }
      end

      def default_fail
        Dox.config.schema_request_fail_file_path.presence
      end
    end
  end
end
