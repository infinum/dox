module Dox
  module Entities
    class Resource
      attr_reader :name, :desc, :group
      attr_accessor :actions

      def initialize(details)
        @name = details[:resource_name]
        @group = details[:resource_group_name]
        @desc = details[:resource_desc]
        @actions = {}
      end
    end
  end
end
