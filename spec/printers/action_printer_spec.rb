describe Dox::Printers::ActionPrinter do
  subject { described_class }

  let(:request) { double(:request, method: 'GET', path_parameters: { 'id' => 1 }, path: '/pokemons/1') }
  let(:uri_params) do
    {
      id: { type: :number, required: :required, value: 2, description: 'pokemon id', default: 1 }
    }
  end

  let(:details) do
    {
      action_desc: 'Returns a Pokemon',
      action_params: uri_params
    }
  end
  let(:action_without_params) { Dox::Entities::Action.new('Get Pokemon', details.except(:action_params), request) }
  let(:action_with_params) { Dox::Entities::Action.new('Get Pokemon', details, request) }

  let(:hash) { {} }
  let(:printer) { described_class.new(hash) }

  before do
  end

  describe '#print' do
    let(:action_uri_output) do
      [{ in: :header, name: :id, required: :required, schema: { type: :string } }]
    end

    it 'prints action header' do
      printer.print(action_without_params)
      expect(hash['/pokemons/{id}']['get']['parameters']).to eq(action_uri_output)
    end

    context 'with uri params' do
      it 'prints uri params' do
        printer.print(action_with_params)
        expect(hash['/pokemons/{id}']['get']['parameters'] == uri_params)
      end
    end

    context 'with one example' do
      let(:response) { double(:response) }
      let(:example_details) { { description: 'Returns a Pokemon', resource_name: 'test' } }
      let(:example) { Dox::Entities::Example.new(example_details, request, response) }

      before do
        action_without_params.examples << example
        expect_any_instance_of(Dox::Printers::ExamplePrinter).to receive(:print).once
      end

      it 'triggers example printer once' do
        printer.print(action_without_params)
      end
    end
  end
end
