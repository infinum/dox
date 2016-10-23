describe Dox::DSL::Resource do
  subject { described_class }

  RESOURCE_NAME = 'Pokemons'.freeze
  RESOURCE_GROUP = 'Pokemons'.freeze
  RESOURCE_ENDPOINT = '/pokemons'.freeze
  RESOURCE_DESC = 'Returns list of Pokemons'.freeze

  let(:options) do
    proc do
      group RESOURCE_GROUP
      endpoint RESOURCE_ENDPOINT
      desc RESOURCE_DESC
    end
  end

  let(:options_without_group) do
    proc do
      endpoint RESOURCE_ENDPOINT
      desc RESOURCE_DESC
    end
  end

  let(:options_without_endpoint) do
    proc do
      group RESOURCE_GROUP
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

      it 'raises error when endpoint is not specified' do
        expect do
          subject.new(RESOURCE_NAME, &options_without_endpoint)
        end.to raise_error(Dox::Errors::InvalidResourceError, /endpoint is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes resource' do
        expect do
          subject.new(RESOURCE_NAME, &options)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource) { subject.new(RESOURCE_NAME, &options) }
    it { expect(resource.config[:resource_name]).to eq(RESOURCE_NAME) }
    it { expect(resource.config[:resource_group_name]).to eq(RESOURCE_GROUP) }
    it { expect(resource.config[:resource_endpoint]).to eq(RESOURCE_ENDPOINT) }
    it { expect(resource.config[:resource_desc]).to eq(RESOURCE_DESC) }
  end
end
