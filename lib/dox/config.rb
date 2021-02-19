module Dox
  class Config
    attr_reader :schema_request_folder_path
    attr_reader :schema_response_folder_path
    attr_reader :schema_response_fail_file_path
    attr_accessor :headers_whitelist
    attr_accessor :openapi_version
    attr_accessor :api_version
    attr_accessor :title
    attr_accessor :header_description
    attr_accessor :groups_order
    attr_reader :descriptions_location

    def descriptions_location=(folder_path)
      raise(Errors::FolderNotFoundError, folder_path) unless Dir.exist?(folder_path)

      @descriptions_location = folder_path
    end

    def schema_request_folder_path=(folder_path)
      raise(Errors::FolderNotFoundError, folder_path) unless Dir.exist?(folder_path)

      @schema_request_folder_path = folder_path
    end

    def schema_response_folder_path=(folder_path)
      raise(Errors::FolderNotFoundError, folder_path) unless Dir.exist?(folder_path)

      @schema_response_folder_path = folder_path
    end

    def schema_response_fail_file_path=(file_path)
      raise(Errors::FileNotFoundError, file_path) unless File.exist?(file_path)

      @schema_response_fail_file_path = file_path
    end

    def desc_folder_path=(folder_path)
      warn(
        'DEPRECATION WARNING: desc_folder_path will be removed in the next release, please use descriptions_location instead' # rubocop:disable Layout/LineLength
      )

      self.descriptions_location = folder_path
    end

    def header_file_path=(_file_path)
      warn('WARNING: header_file_path is no longer used. Move header description to config.header_description.')
    end
  end
end
