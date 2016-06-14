module Dox
  module DSL
    class ResourceGroup
      include AttrProxy

      attr_writer :name
      attr_writer :desc

      def initialize(opts = {})
        self.name = opts.fetch(:name, nil)
        self.desc = opts.fetch(:desc, nil)
      end

      def config
        {}.tap do |config|
          config[:resource_group_name] = @name if @name
          config[:resource_group_desc] = @desc if @desc
          config[:apidoc] = true
        end
      end
    end
  end
end
