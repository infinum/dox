describe Dox::DSL::Action do
  subject { described_class }

  ACTION_NAME = 'Get pokemons'.freeze
  ACTION_URI_PARAMS = { id: 1 }.freeze
  ACTION_VERB = 'GET'.freeze
  ACTION_PATH = '/pokemons'.freeze
  ACTION_DESC = 'Returns list of Pokemons'.freeze

  let(:options) do
    proc do
      verb ACTION_VERB
      path ACTION_PATH
      desc ACTION_DESC
      params ACTION_URI_PARAMS
    end
  end

  let(:options_with_name) do
    proc do
      name ACTION_NAME
      verb ACTION_VERB
      path ACTION_PATH
      desc ACTION_DESC
      params ACTION_URI_PARAMS
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

    context 'when name is defined via block' do
      it 'initializes action' do
        expect do
          subject.new(ACTION_NAME, &options_with_name)
        end.not_to raise_error
      end
    end

    context 'when block is not given' do
      it 'initializes action' do
        expect do
          subject.new(ACTION_NAME)
        end.not_to raise_error
      end
    end
  end

  describe '#config' do
    let(:action) { subject.new(ACTION_NAME, &options) }
    it { expect(action.config[:action_name]).to eq(ACTION_NAME) }
    it { expect(action.config[:action_verb]).to eq(ACTION_VERB) }
    it { expect(action.config[:action_path]).to eq(ACTION_PATH) }
    it { expect(action.config[:action_desc]).to eq(ACTION_DESC) }
    it { expect(action.config[:action_params]).to eq(ACTION_URI_PARAMS) }
  end
end
