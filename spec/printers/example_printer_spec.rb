describe Dox::Printers::ExamplePrinter do
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
    context 'without request parameters and response body' do
      context 'without whitelisted headers' do
        before do
          allow(example).to receive(:request_body).and_return('')
          allow(example).to receive(:response_body).and_return('')
          printer.print(example)
        end

        it do
          expect(hash['responses'][response.status.to_s]['content']).to eq(content_type.to_s => {})
          expect(hash['requestBody']['content']).to eq(content_type.to_s => {})
        end
      end

      context 'with whitelisted case sensitive headers' do
        let(:response_header_output) { { 'application/json' => {} } }

        before do
          Dox.config.headers_whitelist = ['X-Auth-Token', 'Content-Encoding', 'Cache-Control']
          allow(example).to receive(:request_body).and_return('')
          allow(example).to receive(:response_body).and_return('')
          printer.print(example)
        end

        it do
          expect(hash['responses'][response.status.to_s]['content']).to eq(response_header_output)
        end
      end
    end

    context 'with request parameters and response body' do
      let(:response_body) { { 'data' => { id: 1, name: 'Pikachu' } }.to_json }
      let(:request_body) { { 'data' => { name: 'Pikachu', type: 'Electric' } }.to_json }

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

      let(:req_headers) { { 'Accept' => content_type } }

      before do
        Dox.config.headers_whitelist = nil
        allow(example).to receive(:request_body).and_return(request_body)
        allow(example).to receive(:response_body).and_return(response_body)
        printer.print(example)
      end

      it 'contains rsponse' do
        content = hash['responses']['200']['content']

        expect(content[content_type.to_s]['examples'][details[:description]]['value']).to eq(response_body_output)
      end

      it 'contains request' do
        content = hash['requestBody']['content'][content_type.to_s]
        expect(content['examples'][details[:description]]['value']).to eq(request_body_output)
      end
    end

    context 'with empty string as a body' do
      before do
        allow(example).to receive(:request_body).and_return('')
        allow(example).to receive(:response_body).and_return('')
        printer.print(example)
      end

      it 'deos not have example hash' do
        content = hash['responses']['200']['content']

        expect(content[content_type.to_s].key?('examples')).to eq(false)
      end
    end

    context 'with regular body' do
      let(:content_type) { 'application/vnd.api+json' }
      let(:response_body) { { 'data' => { 'id' => 1, 'attributes' => { name: 'Pikachu' } } }.to_json }
      let(:response_body_output) do
        JSON.parse(
          '{
              "id": 1,
              "attributes": {
                "name": "Pikachu"
              }
           }'
        )
      end

      before do
        allow(example).to receive(:response_body).and_return(response_body)
        allow(example).to receive(:request_body).and_return('')
        printer.print(example)
      end

      it 'contains formatted body' do
        content = hash['responses']['200']['content']
        expect(content[content_type.to_s]['examples'][details[:description]]['value']).to eq(response_body_output)
      end
    end
  end
end
