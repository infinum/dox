module Dox
  module Entities
    class Action

      attr_accessor :name, :desc, :verb, :path, :uri_params, :examples

      def initialize(name, details)
        @name = name
        @desc = details[:action_desc]
        @verb = details[:action_verb]
        @path = details[:action_path]
        @uri_params = details[:action_params]
        @examples = []
      end

    end
  end
end
