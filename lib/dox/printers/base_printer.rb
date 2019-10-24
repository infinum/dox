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

      def find_or_add(hash, key, default = {})
        return hash[key] if hash.key?(key)

        hash[key] = default
      end

      def formatted_body(body_str, content_type)
        case content_type
        when %r{application\/.*json}
          JSON.parse(body_str)
        when /xml/
          pretty_xml(body_str)
        else
          body_str
        end
      end

      def pretty_xml(xml_string)
        doc = REXML::Document.new(xml_string)
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        result = ''
        formatter.write(doc, result)
        result
      end
    end
  end
end
