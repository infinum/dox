describe Dox::Printers::ActionPrinter do
  subject { described_class }

  let(:request) do
    double(:request, method: 'GET',
                     path_parameters: { 'id' => 1 },
                     path: '/pokemons/1',
                     filtered_parameters: {},
                     env: {})
  end
  let(:params) do
    {
      id: { type: :number, value: 2, description: 'pokemon id', default: 1 }
    }
  end

  let(:all_params) do
    [
      { example: 1,
        in: :path,
        name: :id,
        schema: { type: :string } },
      { description: 'pokemon id',
        example: 2,
        in: 'query',
        name: :id,
        required: nil,
        schema: nil,
        type: :number }
    ]
  end

  let(:details) do
    {
      action_name: 'Get Pokemon',
      action_desc: 'Returns a Pokemon',
      action_params: params
    }
  end
  let(:action_without_params) { Dox::Entities::Action.new(details.except(:action_params), request) }
  let(:action_with_params) { Dox::Entities::Action.new(details, request) }

  let(:hash) { {} }
  let(:printer) { described_class.new(hash) }

  describe '#print' do
    let(:action_output) do
      [{ example: 1, in: :path, name: :id, schema: { type: :string } }]
    end

    it 'prints action header' do
      printer.print(action_without_params)
      expect(hash['/pokemons/{id}'][:get]['parameters']).to eq(action_output)
    end

    context 'with params' do
      it 'prints params' do
        printer.print(action_with_params)
        expect(hash['/pokemons/{id}'][:get]['parameters']).to eq(all_params)
      end
    end

    context 'with one example' do
      let(:response) { double(:response) }
      let(:example_details) { { description: 'Returns a Pokemon', resource_name: 'test' } }
      let(:example) { Dox::Entities::Example.new(example_details, request, response) }

      before do
        action_without_params.examples << example
        expect_any_instance_of(Dox::Printers::ExampleRequestPrinter).to receive(:print).once
        expect_any_instance_of(Dox::Printers::ExampleResponsePrinter).to receive(:print).once
      end

      it 'triggers example printer once' do
        printer.print(action_without_params)
      end
    end
  end
end
