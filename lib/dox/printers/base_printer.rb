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

      def acquire_header(header, fullpath = false)
        return if header.blank?

        if header.to_s =~ /.*\.json$/
          header = content(acquire_path(header, fullpath))
          adjust_description(header['info'])
        end

        header
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

      def adjust_description(info)
        info['description'] = acquire_desc(info['description']) if info['description'].end_with?('.md')
      end

      def acquire_desc(path)
        File.read(File.join(Dox.config.desc_folder_path, path))
      end
    end
  end
end
