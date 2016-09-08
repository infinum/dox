module Dox
  module DSL
    class ResourceGroup
      include AttrProxy

      attr_writer :name
      attr_writer :desc

      def initialize(opts = {})
        self.name = opts.fetch(:name, nil)
        raise(Dox::Errors::InvalidResourceGroupError, 'Resource group name is required!') if @name.blank?

        self.desc = opts.fetch(:desc, nil)
      end

      def config
        {}.tap do |config|
          config[:resource_group_name] = @name.presence
          config[:resource_group_desc] = @desc.presence
          config[:apidoc] = true
        end
      end
    end
  end
end
