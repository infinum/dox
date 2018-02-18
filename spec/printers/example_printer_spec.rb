describe Dox::Printers::ExamplePrinter do
  subject { described_class }

  let(:content_type) { 'application/json' }
  let(:req_headers) { { 'X-Auth-Token' => '877da7da7fbc16216e' } }
  let(:res_headers) { { 'Content-Type' => content_type, 'Content-Encoding' => 'gzip', 'cache-control' => 'public' } }
  let(:response) { double('response', content_type: content_type, status: 200, body: nil, headers: res_headers) }
  let(:request) { double('request', content_type: content_type, headers: req_headers, query_parameters: {}, path_parameters: {}, method: 'GET', path: '/pokemons/1', fullpath: '/pokemons/1') }
  let(:details) { { description: 'Returns a Pokemon' } }

  let(:example) { Dox::Entities::Example.new(details, request, response) }

  let(:output) { double(:output) }
  let(:printer) { described_class.new(output) }

  before do
    allow(output).to receive(:puts)
    allow(request).to receive(:parameters).and_return({})
  end

  describe '#print' do
    context 'without request parameters and response body' do
      before do
        allow(request).to receive(:body).and_return(StringIO.new())
      end

      let(:request_title_output) do
        <<-HEREDOC

+ Request Returns a Pokemon
**GET**&nbsp;&nbsp;`/pokemons/1`
        HEREDOC
      end

      let(:response_id_output) do
        <<-HEREDOC

+ Response 200
        HEREDOC
      end

      context 'without whitelisted headers' do
        let(:request_empty_headers_output) do
          <<-HEREDOC

    + Headers


          HEREDOC
        end

        let(:response_headers_output) do
          <<-HEREDOC

    + Headers

            Content-Type: application/json
          HEREDOC
        end

        before { printer.print(example) }
        it { expect(output).to have_received(:puts).exactly(4).times }
        it { expect(output).to have_received(:puts).with(request_title_output).once }
        it { expect(output).to have_received(:puts).with(request_empty_headers_output).once }

        it { expect(output).to have_received(:puts).with(response_headers_output).once }
        it { expect(output).to have_received(:puts).with(response_id_output).once }
      end

      context 'with whitelisted case sensitive headers' do
        let(:request_headers_output) do
          <<-HEREDOC

    + Headers

            X-Auth-Token: 877da7da7fbc16216e
          HEREDOC
        end

        let(:response_headers_output) do
          <<-HEREDOC

    + Headers

            Content-Encoding: gzip
            Content-Type: application/json
          HEREDOC
        end

        before { Dox.config.headers_whitelist = ['X-Auth-Token', 'Content-Encoding', 'Cache-Control'] }
        before { printer.print(example) }
        it { expect(output).to have_received(:puts).with(request_title_output).once }
        it { expect(output).to have_received(:puts).with(response_id_output).once }
        it { expect(output).to have_received(:puts).with(request_headers_output).once }
        it { expect(output).to have_received(:puts).with(response_headers_output).once }
      end
    end

    context 'with request parameters and response body' do
      let(:response_body) { { id: 1, name: 'Pikachu' }.to_json }
      let(:request_body) { { 'name' => 'Pikachu', type: 'Electric' }.to_json }

      # indentation matters here
      let(:response_body_output) do
        <<-HEREDOC

    + Body

            {
              "id": 1,
              "name": "Pikachu"
            }
        HEREDOC
      end

      let(:request_body_output) do
        <<-HEREDOC

    + Body

            {
              "name": "Pikachu",
              "type": "Electric"
            }
        HEREDOC
      end

      before do
        allow(request).to receive(:body).and_return(StringIO.new(request_body))
        allow(response).to receive(:body).and_return(response_body)
      end

      before { printer.print(example) }

      it { expect(output).to have_received(:puts).exactly(6).times }
      it { expect(output).to have_received(:puts).with(request_body_output).once }
      it { expect(output).to have_received(:puts).with(response_body_output).once }
    end

    context 'with empty string as a body' do
      before do
        allow(request).to receive(:body).and_return(StringIO.new)
        allow(response).to receive(:body).and_return('')
      end

      before { printer.print(example) }
      it { expect(output).to have_received(:puts).exactly(4).times }
    end

    context 'with XML body' do
      let(:content_type) { 'text/xml' }
      let(:response_body) { '<note><from>Jani</from>  <to>Tove</to><message>Remember me this weekend</message></note>' }
      let(:response_body_output) do
        <<-HEREDOC

    + Body

            <note>
              <from>Jani</from>
              <to>Tove</to>
              <message>Remember me this weekend</message>
            </note>
        HEREDOC
      end

      before do
        allow(request).to receive(:body).and_return(StringIO.new)
        allow(response).to receive(:body).and_return(response_body)
      end

      it 'prints formatted XML body' do
        printer.print(example)
        expect(output).to have_received(:puts).with(response_body_output).once
      end
    end

    context 'with JSON API body' do
      let(:content_type) { 'application/vnd.api+json' }
      let(:response_body) { { 'data' => { 'id' => 1, 'attributes' => { 'name' => 'Pikachu' } } }.to_json }
      let(:response_body_output) do
        <<-HEREDOC

    + Body

            {
              "data": {
                "id": 1,
                "attributes": {
                  "name": "Pikachu"
                }
              }
            }
        HEREDOC
      end

      before do
        allow(request).to receive(:body).and_return(StringIO.new)
        allow(response).to receive(:body).and_return(response_body)
      end

      it 'prints formatted JSON API body' do
        printer.print(example)
        expect(output).to have_received(:puts).with(response_body_output).once
      end
    end

    context 'with plain text body' do
      let(:content_type) { 'text/plain' }
      let(:response_body) { 'A message from the dark side there is.' }
      let(:response_body_output) do
        <<-HEREDOC

    + Body

            A message from the dark side there is.
        HEREDOC
      end

      before do
        allow(request).to receive(:body).and_return(StringIO.new)
        allow(response).to receive(:body).and_return(response_body)
      end

      it 'prints plain text body' do
        printer.print(example)
        expect(output).to have_received(:puts).with(response_body_output).once
      end
    end
  end
end
