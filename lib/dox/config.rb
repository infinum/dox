module Dox
  class Config

    attr_accessor :header_file_path, :desc_folder_path

    def initialize
      @header_file_path = 'api.md'
      @desc_folder_path = Rails.root.join('')
    end

  end
end

