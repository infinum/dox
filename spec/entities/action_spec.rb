describe Dox::Entities::Action do
  subject { described_class }

  let(:action_name) { 'Get pokemons' }
  let(:request) { double(:request, method: 'HEAD', path_parameters: { 'id' => 1 }, path: '/pokemons/1') }
  let(:details) do
    {
      action_desc: 'Returns a list of pokemons',
      action_verb: 'GET',
      action_path: '/pokemons',
      action_params: {}
    }
  end

  let(:action) { subject.new(action_name, details, request) }

  describe '#name' do
    it { expect(action.name).to eq(action_name) }
  end

  describe '#desc' do
    it { expect(action.desc).to eq(details[:action_desc]) }
  end

  describe '#verb' do
    context 'when verb is explicitly defined' do
      it { expect(action.verb).to eq(details[:action_verb]) }
    end

    context 'when verb is not explicitly defined' do
      let(:action) { subject.new(action_name, {}, request) }
      it { expect(action.verb).to eq(request.method) }
    end
  end

  describe '#path' do
    context 'when path is explicitly defined' do
      it { expect(action.path).to eq(details[:action_path]) }
    end

    context 'when path is not explicitly defined' do
      let(:action) { subject.new(action_name, {}, request) }
      context 'with one path param' do
        it { expect(action.path).to eq('/pokemons/{id}') }
      end

      context 'with multiple path params' do
        before do
          allow(request).to receive(:path).and_return('/pokemons/electric/11')
          allow(request).to receive(:path_parameters).and_return('id' => 11, 'type' => 'electric')
        end
        it { expect(action.path).to eq('/pokemons/{type}/{id}') }
      end

      context 'when value is substring of path' do
        before do
          allow(request).to receive(:path).and_return('/pokemons/electric/11')
          allow(request).to receive(:path_parameters).and_return('id' => 11, 'type' => 'lec')
        end
        it { expect(action.path).to eq('/pokemons/electric/{id}') }
      end

      # in Rails 5.0.2 request.path returns ""
      context 'when path is empty string and query params are present' do
        before do
          allow(request).to receive(:path).and_return('')
          allow(request).to receive(:fullpath).and_return('/pokemons/electric/11?some_query=123&other=m')
          allow(request).to receive(:path_parameters).and_return('id' => 11, 'type' => 'lec')
        end
        it { expect(action.path).to eq('/pokemons/electric/{id}') }
      end
    end
  end

  describe '#uri_params' do
    context 'when explicitly defined' do
      it { expect(action.uri_params).to eq(details[:action_params]) }
    end

    context 'when not explicitly defined' do
      let(:action) { subject.new(action_name, {}, request) }

      before do
        allow(request).to receive(:path).and_return('/pokemons/electric/11')
        allow(request).to receive(:path_parameters).and_return('id' => 11, 'type' => 'electric')
      end

      context 'when Dox.config.guess_params_from_path is true' do
        before { Dox.config.guess_params_from_path = true }

        let(:uri_params) do
          {
            id: { type: :string, required: :required, value: 11 },
            type: { type: :string, required: :required, value: 'electric' }
          }
        end

        it { expect(action.uri_params).to eq(uri_params) }
      end

      context 'when Dox.config.guess_params_from_path is false' do
        before { Dox.config.guess_params_from_path = false }

        it { expect(action.uri_params).to eq(nil) }
      end
    end
  end

  describe '#examples' do
    it 'is initialized as an empty array' do
      expect(action.examples).to eq([])
    end

    it 'is also a writter' do
      action.examples << 'Pika'
      expect(action.examples).to eq(['Pika'])
    end
  end

  it 'raises error for unrecognized verb' do
    allow(Dox::Util::Http).to receive(:verb?).and_return(false)

    expect { action }.to raise_error(Dox::Error, 'Unrecognized HTTP verb GET')
  end
end
