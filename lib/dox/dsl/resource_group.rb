module Dox
  module DSL
    class ResourceGroup
      include AttrProxy

      attr_writer :name
      attr_writer :desc

      def initialize(name, &block)
        self.name = name
        instance_eval(&block) if block_given?

        raise(Dox::Errors::InvalidResourceGroupError, 'Resource group name is required!') if @name.blank?
      end

      def config
        {
          resource_group_name: @name.presence,
          resource_group_desc: @desc.presence,
          apidoc: true
        }
      end
    end
  end
end
