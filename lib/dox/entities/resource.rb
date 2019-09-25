module Dox
  module Entities
    class Resource
      attr_reader :name, :desc, :endpoint
      attr_accessor :actions

      def initialize(name, details)
        @name = name
        @desc = details[:resource_desc]
        @endpoint = details[:resource_endpoint]
        @actions = {}
      end
    end
  end
end
