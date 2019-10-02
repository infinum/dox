module Dox
  module DSL
    class Resource
      include AttrProxy

      attr_writer :name
      attr_writer :group
      attr_writer :endpoint

      attr_writer :desc
      attr_writer :schema

      def initialize(name, &block)
        self.name = name

        instance_eval(&block)

        raise(Dox::Errors::InvalidResourceError, 'Resource name is required!') if @name.blank?
        raise(Dox::Errors::InvalidResourceError, 'Resource group is required!') if @group.blank?
        raise(Dox::Errors::InvalidResourceError, 'Resource endpoint is required!') if @endpoint.blank?
      end

      def config
        {
          resource_schema: @schema.presence,
          resource_name: @name.presence,
          resource_desc: @desc.presence,
          resource_group_name: @group.presence,
          resource_endpoint: @endpoint.presence,
          apidoc: true
        }
      end
    end
  end
end
