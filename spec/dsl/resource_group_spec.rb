describe Dox::DSL::ResourceGroup do
  subject { described_class }

  GROUP_NAME = 'Pokemons'.freeze
  GROUP_DESC = 'All pokemons'.freeze

  let(:options) do
    proc do
      desc GROUP_DESC
    end
  end

  let(:options_with_name) do
    proc do
      name GROUP_NAME
      desc GROUP_DESC
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
          subject.new(GROUP_NAME, &options)
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
          subject.new(GROUP_NAME)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:resource_group) { subject.new(GROUP_NAME, &options) }
    it { expect(resource_group.config[:resource_group_name]).to eq(GROUP_NAME) }
    it { expect(resource_group.config[:resource_group_desc]).to eq(GROUP_DESC) }
    it { expect(resource_group.config[:apidoc]).to eq(true) }
  end
end
