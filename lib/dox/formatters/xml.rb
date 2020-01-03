module Dox
  module Formatters
    class Xml < Dox::Formatters::Base
      def format
        doc = REXML::Document.new(body)
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        result = ''
        formatter.write(doc, result)
        result
      end
    end
  end
end
