describe Dox::DSL::Action do
  subject { described_class }

  let(:options) do
    {
      name: 'Get pokemons',
      verb: 'GET',
      path: '/pokemons',
      desc: 'Returns list of Pokemons',
      params: { id: 1 }
    }
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(options.except(:name))
        end.to raise_error(Dox::Errors::InvalidActionError, /name is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes action' do
        expect do
          subject.new(options)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:action) { subject.new(options) }
    it { expect(action.config[:action_name]).to eq(options[:name]) }
    it { expect(action.config[:action_verb]).to eq(options[:verb]) }
    it { expect(action.config[:action_path]).to eq(options[:path]) }
    it { expect(action.config[:action_desc]).to eq(options[:desc]) }
    it { expect(action.config[:action_params]).to eq(options[:params]) }
  end
end