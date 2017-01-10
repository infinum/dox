require 'spec_helper'

describe Dox::Printers::ExamplePrinter do
  subject { described_class }

  let(:content_type) { 'application/json' }
  let(:req_headers) { [['X-Auth-Token', '877da7da7fbc16216e']] }
  let(:res_headers) { [['Content-Type', content_type], ['Content-Encoding', 'gzip'], ['cache-control', 'public' ]] }
  let(:response) { double('response', content_type: content_type, status: 200, body: nil, headers: res_headers) }
  let(:request) { double('request', content_type: content_type, headers: req_headers, query_parameters: {}, path_parameters: {}) }
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
      let(:request_id_output) do
        <<-HEREDOC

+ Request Returns a Pokemon
        HEREDOC
      end

      let(:response_id_output) do
        <<-HEREDOC
+ Response 200
        HEREDOC
      end

      context 'without whitelisted headers' do
        let(:response_headers_output) do
          <<-HEREDOC
    + Headers

            Content-Type: application/json

          HEREDOC
        end

        before { printer.print(example) }
        it { expect(output).to have_received(:puts).exactly(2).times }
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

            Content-Type: application/json
            Content-Encoding: gzip

          HEREDOC
        end

        before { Dox.config.headers_whitelist = ['X-Auth-Token', 'Content-Encoding', 'Cache-Control'] }
        before { printer.print(example) }
        it { expect(output).to have_received(:puts).with(request_id_output).once }
        it { expect(output).to have_received(:puts).with(response_id_output).once }
        it { expect(output).to have_received(:puts).with(request_headers_output).once }
        it { expect(output).to have_received(:puts).with(response_headers_output).once }
      end
    end

    context 'with request parameters and response body' do
      let(:response_body) { { id: 1, name: 'Pikachu' }.to_json }
      let(:body_parameters) { { 'name' => 'Pikachu', type: 'Electric' } }

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
        allow(request).to receive(:parameters).and_return(body_parameters)
        allow(response).to receive(:body).and_return(response_body)
      end

      before { printer.print(example) }

      it { expect(output).to have_received(:puts).exactly(6).times }
      it { expect(output).to have_received(:puts).with(request_body_output).once }
      it { expect(output).to have_received(:puts).with(response_body_output).once }
    end

    context 'with empty string as a body' do
      before do
        allow(response).to receive(:body).and_return('')
      end

      before { printer.print(example) }
      it { expect(output).to have_received(:puts).exactly(4).times }
    end
  end
end
