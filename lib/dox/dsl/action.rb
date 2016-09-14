module Dox
  module DSL
    class Action
      include AttrProxy

      attr_writer :name
      attr_writer :verb
      attr_writer :path
      attr_writer :desc
      attr_writer :params

      def initialize(name, &block)
        self.name = name
        instance_eval(&block) if block_given?

        raise(Dox::Errors::InvalidActionError, 'Action name is required!') if @name.blank?
      end

      def config
        {
          action_name: @name.presence,
          action_verb: @verb.presence,
          action_path: @path.presence,
          action_desc: @desc.presence,
          action_params: @params.presence
        }
      end
    end
  end
end
