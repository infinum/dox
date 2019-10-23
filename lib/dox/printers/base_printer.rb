module Dox
  module Printers
    class BasePrinter
      attr_reader :spec

      def initialize(spec)
        @spec = spec || {}
      end

      def print
        raise NotImplementedError
      end

      def find_or_add_hash(hash, key)
        return hash[key] if hash.key?(key)

        hash[key] = {}
      end

      def find_or_add_array(hash, key)
        return hash[key] if hash.key?(key)

        hash[key] = []
      end
    end
  end
end
