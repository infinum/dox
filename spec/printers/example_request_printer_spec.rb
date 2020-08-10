describe Dox::Printers::ExampleRequestPrinter do
  subject { described_class }

  let(:content_type) { 'application/json' }
  let(:req_headers) { { 'X-Auth-Token' => '877da7da7fbc16216e', 'Accept' => content_type } }
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
    context 'without request parameters' do
      context 'without whitelisted headers' do
        before do
          allow(example).to receive(:request_body).and_return('')
          printer.print(example)
        end

        it do
          expect(hash['requestBody']).to eq(nil)
        end
      end
    end

    context 'with request parameters' do
      let(:request_body) { { 'data' => { name: 'Pikachu', type: 'Electric' } }.to_json }

      let(:request_body_output) do
        JSON.parse(
          '{
          "data":
            {
              "name": "Pikachu",
              "type": "Electric"
              }
           }'
        )
      end

      let(:req_headers) { { 'Accept' => content_type } }

      before do
        Dox.config.headers_whitelist = nil
        allow(example).to receive(:request_body).and_return(request_body)
        printer.print(example)
      end

      it 'contains request' do
        content = hash['requestBody']['content'][content_type.to_s]
        expect(content['examples'][details[:description]]['value']).to eq(request_body_output)
      end
    end
  end
end
