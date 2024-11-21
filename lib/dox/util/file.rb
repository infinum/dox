module Dox
  module Util
    module File
      def self.file_path(path, config_root_path: Dox.config.descriptions_location)
        return '' unless config_root_path

        config_root_path.each do |root_path|
          full_path = ::File.join(root_path, path)
          next unless ::File.exist?(full_path)

          return full_path
        end

        nil
      end
    end
  end
end
