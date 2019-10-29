module Dox
  class Config
    attr_reader :body_file_path, :desc_folder_path, :schema_request_folder_path, :schema_response_folder_path,
                :schema_response_fail_file_path
    attr_accessor :headers_whitelist

    def body_file_path=(file_path)
      raise(Errors::FileNotFoundError, file_path) unless File.exist?(file_path)

      @body_file_path = file_path
    end

    def desc_folder_path=(folder_path)
      raise(Errors::FolderNotFoundError, folder_path) unless Dir.exist?(folder_path)

      @desc_folder_path = folder_path
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
  end
end
