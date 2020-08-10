module Dox
  module Entities
    class ResourceGroup
      attr_reader :name
      attr_accessor :desc, :resources

      def initialize(details)
        @name = details[:resource_group_name]
        @desc = details[:resource_group_desc]
        @resources = {}
      end
    end
  end
end
