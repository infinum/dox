module Dox
  module DSL
    class Resource
      include AttrProxy

      attr_writer :name
      attr_writer :group
      attr_writer :endpoint

      attr_writer :desc

      def initialize(opts = {})
        self.name = opts.fetch(:name, nil)
        raise(Dox::Errors::InvalidResourceError, 'Resource name is required!') if @name.blank?

        self.group = opts.fetch(:group, nil)
        raise(Dox::Errors::InvalidResourceError, 'Resource group is required!') if @group.blank?

        self.endpoint = opts.fetch(:endpoint, nil)
        raise(Dox::Errors::InvalidResourceError, 'Resource endpoint is required!') if @endpoint.blank?

        self.desc = opts.fetch(:desc, nil)
      end

      def config
        {}.tap do |config|
          config[:resource_name] = @name.presence
          config[:resource_desc] = @desc.presence
          config[:resource_group_name] = @group.presence
          config[:resource_endpoint] = @endpoint.presence
          config[:apidoc] = true
        end
      end
    end
  end
end
