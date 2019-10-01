module Dox
  module Entities
    class Resource
      attr_reader :name, :desc, :endpoint, :group
      attr_accessor :actions

      def initialize(name, details)
        @name = name
        @group = details[:resource_group_name]
        @desc = details[:resource_desc]
        @endpoint = details[:resource_endpoint]
        @actions = {}
      end
    end
  end
end
