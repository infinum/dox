describe Dox::DSL::ResourceGroup do
  subject { described_class }

  NAME = 'Pokemons'
  DESC = 'All pokemons'

  let(:options) do
    Proc.new do
      desc DESC
    end
  end

  let(:options_with_name) do
    Proc.new do
      name NAME
      desc DESC
    end
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new('', &options)
        end.to raise_error(Dox::Errors::InvalidResourceGroupError, /name is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes resource' do
        expect do
          subject.new(NAME, &options)
        end.not_to raise_error
      end
    end

    context 'when name is defined via block' do
      it 'initializes resource' do
        expect do
          subject.new(nil, &options_with_name)
        end.not_to raise_error
      end
    end

    context 'when block is not defined' do
      it 'initializes resource' do
        expect do
          subject.new(NAME)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource_group) { subject.new(NAME, &options) }
    it { expect(resource_group.config[:resource_group_name]).to eq(NAME) }
    it { expect(resource_group.config[:resource_group_desc]).to eq(DESC) }
    it { expect(resource_group.config[:apidoc]).to eq(true) }
  end
end