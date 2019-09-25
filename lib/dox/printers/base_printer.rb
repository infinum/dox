module Dox
  module Printers
    class BasePrinter
      def initialize(json_hash)
        @json_hash = json_hash
      end

      def print
        raise NotImplementedError
      end

      def existing_hash(hash, key)
        return hash[key] if hash.key?(key)

        hash[key] = {}
      end

      private

      def descriptions_folder_path
        Dox.config.desc_folder_path
      end

      def acquire_desc(desc, fullpath = false)
        return if desc.blank?

        if desc.to_s =~ /.*\.json$/
          content(acquire_path(desc, fullpath))
        else
          desc
        end
      end

      def acquire_path(desc, fullpath = false)
        if fullpath
          desc
        else
          descriptions_folder_path.join(desc).to_s
        end
      end

      def content(path)
        JSON.parse(File.read(path))
      end
    end
  end
end
