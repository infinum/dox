module Dox
  module Printers
    class BasePrinter

      attr_reader :descriptions_folder_path

      def initialize(output)
        @output = output
        @descriptions_folder_path = Dox.config.desc_folder_path
      end

      def print
        raise NotImplementedError
      end

      private

      def print_desc(desc)
        return if desc.blank?

        if desc.to_s =~ /.*\.md$/
          path = descriptions_folder_path.join(desc).to_s
          "<!-- include(#{path}) -->"
        else
          desc
        end
      end

    end
  end
end
