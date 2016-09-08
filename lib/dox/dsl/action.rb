module Dox
  module DSL
    class Action
      include AttrProxy

      attr_writer :name
      attr_writer :verb
      attr_writer :path
      attr_writer :desc
      attr_writer :params

      def initialize(opts = {})
        self.name = opts.fetch(:name, nil)
        raise(Dox::Errors::InvalidActionError, 'Action name is required!') if @name.blank?

        self.verb = opts.fetch(:verb, nil)
        self.path = opts.fetch(:path, nil)
        self.desc = opts.fetch(:desc, nil)
        self.params = opts.fetch(:params, nil)
      end

      def param(signature)
        params << signature
      end

      def config
        Hash.new.tap do |config|
          config[:action_name] = @name.presence
          config[:action_verb] = @verb.presence
          config[:action_path] = @path.presence
          config[:action_desc] = @desc.presence
          config[:action_params] = @params.presence
        end
      end
    end
  end
end
