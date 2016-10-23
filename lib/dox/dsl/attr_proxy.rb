module Dox
  module DSL
    module AttrProxy
      def method_missing(name, value)
        setter = "#{name}="
        return super unless respond_to? setter

        public_send setter, value
      end
    end
  end
end
