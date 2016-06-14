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

      def resource(name = nil, &block)
        self._resource = Resource.new(name: name)
        _resource.instance_eval(&block)
      end

      def action(name = nil, &block)
        self._action = Action.new(name: name)
        _action.instance_eval(&block)
      end

      def group(name = nil, &block)
        self._group = ResourceGroup.new(name: name)
        _group.instance_eval(&block)
      end

      def config
        {}.merge(_resource ? _resource.config : {})
          .merge(_action ? _action.config : {})
          .merge(_group ? _group.config : {})
      end
    end
  end
end
