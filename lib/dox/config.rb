module Dox
  class Config

    attr_accessor :root_api_file, :desc_folder_path

    def initialize
      @root_api_file = 'api.md'
      @desc_folder_path = Rails.root.join('')
    end

  end
end

