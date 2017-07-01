describe Dox::Config do
  subject { described_class }

  let(:config) { subject.new }

  describe '#header_file_path=' do
    it 'raises an error when the file does not exist' do
      expect do
        config.header_file_path = 'Randomfile.md'
      end.to raise_error(Dox::Errors::FileNotFoundError, 'Randomfile.md')
    end

    it 'sets the attribute when the file exists' do
      config.header_file_path = 'Rakefile'
      expect(config.header_file_path).to eq('Rakefile')
    end
  end

  describe '#desc_folder_path=' do
    it 'raises an error when the folder does not exist' do
      expect do
        config.desc_folder_path = 'spec/mydir'
      end.to raise_error(Dox::Errors::FolderNotFoundError, 'spec/mydir')
    end

    it 'sets the attribute when the folder exists' do
      config.desc_folder_path = 'spec/printers'
      expect(config.desc_folder_path).to eq('spec/printers')
    end
  end

  describe '#body_format=' do
    it 'sets one of the :json or :query attribute' do
      expect(config.body_format = :json).to eq :json
      expect(config.body_format = :query).to eq :query
    end

    it 'raises and error when the value is not :json or :query' do
      expect{ config.body_format = :some_wrong_val }.to raise_error(Dox::Errors::InvalidBodyFormatError)
    end
  end

  describe '#body_format' do
    it 'is :json by default' do
      expect(config.body_format).to eq :json
    end

    it 'is return correct value if set' do
      config.body_format = :query
      expect(config.body_format).to eq :query
      config.body_format = :json
    end
  end
end
