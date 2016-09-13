describe Dox::DSL::ResourceGroup do
  subject { described_class }

  let(:options) do
    {
      name: 'Pokemons',
      desc: 'All pokemons'
    }
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(options.except(:name))
        end.to raise_error(Dox::Errors::InvalidResourceGroupError, /name is required/)
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
    let(:resource_group) { subject.new(options) }
    it { expect(resource_group.config[:resource_group_name]).to eq(options[:name]) }
    it { expect(resource_group.config[:resource_group_desc]).to eq(options[:desc]) }
    it { expect(resource_group.config[:apidoc]).to eq(true) }
  end
end