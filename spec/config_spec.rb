describe Dox::Config do
  subject { described_class }

  let(:config) { subject.new }

  describe '#descriptions_location=' do
    it 'raises an error when the folder does not exist' do
      expect do
        config.descriptions_location = 'spec/mydir'
      end.to raise_error(Dox::Errors::FolderNotFoundError, 'spec/mydir')
    end

    it 'sets the attribute when the folder exists' do
      config.desc_folder_path = 'spec/printers'
      expect(config.descriptions_location).to eq('spec/printers')
    end
  end
end
