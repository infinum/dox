describe Dox::DSL::Resource do
  subject { described_class }

  NAME = 'Pokemons'
  GROUP = 'Pokemons'
  ENDPOINT = '/pokemons'
  DESC = 'Returns list of Pokemons'

  let(:options) do
    Proc.new do
      group GROUP
      endpoint ENDPOINT
      desc DESC
    end
  end

  let(:options_without_group) do
    Proc.new do
      endpoint ENDPOINT
      desc DESC
    end
  end

  let(:options_without_endpoint) do
    Proc.new do
      group GROUP
      desc DESC
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
          subject.new(NAME, &options_without_group)
        end.to raise_error(Dox::Errors::InvalidResourceError, /group is required/)
      end

      it 'raises error when endpoint is not specified' do
        expect do
          subject.new(NAME, &options_without_endpoint)
        end.to raise_error(Dox::Errors::InvalidResourceError, /endpoint is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes resource' do
        expect do
          subject.new(NAME, &options)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource) { subject.new(NAME, &options) }
    it { expect(resource.config[:resource_name]).to eq(NAME) }
    it { expect(resource.config[:resource_group_name]).to eq(GROUP) }
    it { expect(resource.config[:resource_endpoint]).to eq(ENDPOINT) }
    it { expect(resource.config[:resource_desc]).to eq(DESC) }
  end
end