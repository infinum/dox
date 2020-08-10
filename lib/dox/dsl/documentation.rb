module Dox
  module DSL
    class Documentation
      attr_accessor :subject
      attr_accessor :_resource
      attr_accessor :_action
      attr_accessor :_group

      def initialize(opts = {})
        self.subject = opts.fetch :subject
      end

      def resource(name, &block)
        self._resource = Resource.new(name, &block)
      end

      alias tag resource

      def action(name, &block)
        self._action = Action.new(name, &block)
      end

      def group(name, &block)
        self._group = ResourceGroup.new(name, &block)
      end

      alias x_tag group

      def config
        {}.merge(_resource ? _resource.config : {})
          .merge(_action ? _action.config : {})
          .merge(_group ? _group.config : {})
      end
    end
  end
end
