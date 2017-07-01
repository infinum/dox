module Dox
  class Config
    attr_reader :header_file_path, :desc_folder_path
    attr_accessor :headers_whitelist

    def header_file_path=(file_path)
      raise(Errors::FileNotFoundError, file_path) unless File.exist?(file_path)
      @header_file_path = file_path
    end

    def desc_folder_path=(folder_path)
      raise(Errors::FolderNotFoundError, folder_path) unless Dir.exist?(folder_path)
      @desc_folder_path = folder_path
    end

    def body_format=(format)
      raise(Errors::InvalidBodyFormatError, format) unless %i[json query].include? format
      @body_format = format
    end

    def body_format
      @body_format || :json
    end
  end
end
