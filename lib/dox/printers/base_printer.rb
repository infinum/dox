module Dox
  module Printers
    class BasePrinter
      attr_reader :content_encoder

      def initialize(output)
        @output = output
        @content_encoder = Dox.config.post_process ? PathAnotation.new : PathContent.new
      end

      def print
        raise NotImplementedError
      end

      private

      def descriptions_folder_path
        Dox.config.desc_folder_path
      end

      def print_desc(desc, fullpath = false)
        return if desc.blank?

        if desc.to_s =~ /.*\.md$/
          if fullpath
            path = desc
          else
            path = descriptions_folder_path.join(desc).to_s
          end

          content_encoder.descriptor(path)
        else
          desc
        end
      end

      class PathAnotation
        def descriptor(path)
          "<!-- include(#{path}) -->"
        end
      end

      class PathContent
        def descriptor(path)
          File.read(path)
        end
      end
    end
  end
end
