module Dox
  module DSL
    class Resource
      include AttrProxy

      attr_writer :name
      attr_writer :group
      attr_writer :desc
      attr_writer :endpoint

      def initialize(opts = {})
        self.name = opts.fetch(:name, nil)
        self.desc = opts.fetch(:desc, nil)
        self.group = opts.fetch(:group, nil)
        self.endpoint = opts.fetch(:endpoint, nil)
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
