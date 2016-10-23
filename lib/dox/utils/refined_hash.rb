module Dox
  module Utils
    module RefinedHash
      refine Hash do
        def symbolize_keys
          h = {}
          each { |key, v| h[key.to_sym] = v }
          h
        end
      end
    end
  end
end
