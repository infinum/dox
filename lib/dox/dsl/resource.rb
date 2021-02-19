module Dox
  module DSL
    class Resource
      include AttrProxy

      attr_writer :name
      attr_writer :group
      attr_writer :endpoint

      attr_writer :desc

      def initialize(name, &block)
        self.name = name

        instance_eval(&block)

        raise(Dox::Errors::InvalidResourceError, 'Resource name is required!') if @name.blank?
        raise(Dox::Errors::InvalidResourceError, 'Resource group is required!') if @group.blank?
      end

      def config
        {
          resource_name: @name.presence,
          resource_desc: @desc.presence,
          resource_group_name: @group.presence,
          apidoc: true
        }
      end
    end
  end
end
