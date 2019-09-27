describe Dox::Printers::ExamplePrinter do
  subject { described_class }

  let(:content_type) { 'application/json' }
  let(:req_headers) { { 'X-Auth-Token' => '877da7da7fbc16216e' } }
  let(:res_headers) { { 'Content-Type' => content_type, 'Content-Encoding' => 'gzip', 'cache-control' => 'public' } }
  let(:response) { double('response', content_type: content_type, status: 200, body: nil, headers: res_headers) }
  let(:request) do
    double('request',
           content_type: content_type,
           headers: req_headers,
           query_parameters: {},
           path_parameters: {},
           method: 'GET',
           path: '/pokemons/1',
           fullpath: '/pokemons/1')
  end
  let(:details) { { description: 'Returns a Pokemon', resource_name: 'Pokemons' } }

  let(:example) { Dox::Entities::Example.new(details, request, response) }

  let(:hash) { {} }
  let(:printer) { described_class.new(hash) }

  before do
    allow(output).to receive(:puts)
    allow(request).to receive(:parameters).and_return({})
  end

  describe '#print' do
    context 'without request parameters and response body' do
      context 'without whitelisted headers' do
      end

      context 'with whitelisted case sensitive headers' do
      end
    end

    context 'with request parameters and response body' do
      let(:response_body) { { id: 1, name: 'Pikachu' }.to_json }
      let(:request_body) { { 'name' => 'Pikachu', type: 'Electric' }.to_json }

      let(:response_body_output) do
        JSON.parse(
          '{
            "id": 1,
            "name": "Pikachu"
          }'
        )
      end

      let(:request_body_output) do
        JSON.parse(
          '{
            "name": "Pikachu",
            "type": "Electric"
          }'
        )
      end
    end

    context 'with empty string as a body' do
      before do
        allow(example).to receive(:request_body).and_return('')
        allow(example).to receive(:response_body).and_return('')
        printer.print(example)
      end

      it 'deos not have example' do
        #binding.pry
        content = hash['responses']['200']['content']

        expect(content["Content-Type\: #{content_type}"].key?('example')).to eq(false)
      end
    end

    context 'with regular body' do
      let(:content_type) { 'application/vnd.api+json' }
      let(:response_body) { { 'data' => { 'id' => 1, 'attributes' => { 'name' => 'Pikachu' } } }.to_json }
      let(:response_body_output) do
        JSON.parse(
          '{
            "data": {
              "id": 1,
              "attributes": {
                "name": "Pikachu"
              }
            }
           }'
        )
      end

      before do
        printer.print(example)
      end

      it 'contains formatted body' do
        content = hash['responses']['200']['content']

        expect(content["Content-Type\: #{content_type}"]['example']).to eq(response_body_output)
      end
    end
  end
end
