describe Dox::Config do
  subject { described_class }

  let(:config) { subject.new }

  describe '#body_file_path=' do
    it 'raises an error when the file does not exist' do
      expect do
        config.body_file_path = 'Randomfile.md'
      end.to raise_error(Dox::Errors::FileNotFoundError, 'Randomfile.md')
    end

    it 'sets the attribute when the file exists' do
      config.body_file_path = 'Rakefile'
      expect(config.body_file_path).to eq('Rakefile')
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
end
