describe Dox::DSL::Action do
  subject { described_class }

  ACTION_NAME = 'Get pokemons'
  URI_PARAMS = { id: 1 }
  VERB = 'GET'
  PATH = '/pokemons'
  DESC = 'Returns list of Pokemons'

  let(:options) do
    Proc.new do
      verb VERB
      path PATH
      desc DESC
      params URI_PARAMS
    end
  end

  describe '#initialize' do
    context 'when missing required attributes' do
      it 'raises error when name is not specified' do
        expect do
          subject.new(nil, &options)
        end.to raise_error(Dox::Errors::InvalidActionError, /name is required/)
      end
    end

    context 'when required attributes present' do
      it 'initializes action' do
        expect do
          subject.new(ACTION_NAME, &options)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:action) { subject.new(ACTION_NAME, &options) }
    it { expect(action.config[:action_name]).to eq(ACTION_NAME) }
    it { expect(action.config[:action_verb]).to eq(VERB) }
    it { expect(action.config[:action_path]).to eq(PATH) }
    it { expect(action.config[:action_desc]).to eq(DESC) }
    it { expect(action.config[:action_params]).to eq(URI_PARAMS) }
  end
end