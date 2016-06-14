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
          config[:action_name] = @name if @name
          config[:action_verb] = @verb if @verb
          config[:action_path] = @path if @path
          config[:action_desc] = @desc if @desc
          config[:action_params] = @params if @params
        end
      end
    end
  end
end
