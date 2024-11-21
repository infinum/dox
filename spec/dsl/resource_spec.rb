describe Dox::DSL::Resource do
  subject { described_class }

  RESOURCE_NAME = 'Pokemons'.freeze
  RESOURCE_GROUP = 'Pokemons'.freeze
  RESOURCE_DESC = 'Returns list of Pokemons'.freeze

  let(:options) do
    proc do
      group RESOURCE_GROUP
      desc RESOURCE_DESC
    end
  end

  let(:options_without_group) do
    proc do
      desc RESOURCE_DESC
    end
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(' ', &options)
        end.to raise_error(Dox::Errors::InvalidResourceError, /name is required/)
      end

      it 'raises error when group is not specified' do
        expect do
          subject.new(RESOURCE_NAME, &options_without_group)
        end.to raise_error(Dox::Errors::InvalidResourceError, /group is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes resource' do
        expect do
          subject.new(RESOURCE_NAME, &options)
        end.not_to raise_error
      end
    end

    context 'when desc is a file that does not exist' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(RESOURCE_NAME) do
            group RESOURCE_GROUP
            desc 'unknown_file.md'
          end
        end.to raise_error(Dox::Errors::InvalidResourceError, /unknown_file.md is missing/)
      end
    end

    context 'when desc is a file that does exist' do
      it 'initializes resource' do
        allow(Dox::Util::File).to receive(:file_path).with('known_file.md').and_return('Some text')

        expect do
          subject.new(RESOURCE_NAME) do
            group RESOURCE_GROUP
            desc 'known_file.md'
          end
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource) { subject.new(RESOURCE_NAME, &options) }
    it { expect(resource.config[:resource_name]).to eq(RESOURCE_NAME) }
    it { expect(resource.config[:resource_group_name]).to eq(RESOURCE_GROUP) }
    it { expect(resource.config[:resource_desc]).to eq(RESOURCE_DESC) }
  end
end
