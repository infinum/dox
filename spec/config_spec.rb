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
      expect(config.descriptions_location).to eq(['spec/printers'])
    end

    context 'when attribute is an array' do
      context 'when one of the folders in array are missing' do
        it 'raises an error' do
          expect do
            config.descriptions_location = ['spec/printers', 'spec/mydir']
          end.to raise_error(Dox::Errors::FolderNotFoundError, 'spec/mydir')
        end
      end

      context 'when all folders in array are present' do
        it 'sets the attribute value to the array' do
          expected_array = ['spec/printers', 'spec/formatters']
          config.desc_folder_path = expected_array

          expect(config.descriptions_location).to eq(expected_array)
        end
      end
    end
  end
end
