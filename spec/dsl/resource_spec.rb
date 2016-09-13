describe Dox::DSL::Resource do
  subject { described_class }

  let(:options) do
    {
      name: 'Pokemons',
      group: 'Pokemons',
      endpoint: '/pokemons',
      desc: 'Returns list of Pokemons'
    }
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(options.except(:name))
        end.to raise_error(Dox::Errors::InvalidResourceError, /name is required/)
      end

      it 'raises error when group is not specified' do
        expect do
          subject.new(options.except(:group))
        end.to raise_error(Dox::Errors::InvalidResourceError, /group is required/)
      end

      it 'raises error when endpoint is not specified' do
        expect do
          subject.new(options.except(:endpoint))
        end.to raise_error(Dox::Errors::InvalidResourceError, /endpoint is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes resource' do
        expect do
          subject.new(options)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource) { subject.new(options) }
    it { expect(resource.config[:resource_name]).to eq(options[:name]) }
    it { expect(resource.config[:resource_group_name]).to eq(options[:group]) }
    it { expect(resource.config[:resource_endpoint]).to eq(options[:endpoint]) }
    it { expect(resource.config[:resource_desc]).to eq(options[:desc]) }
  end
end