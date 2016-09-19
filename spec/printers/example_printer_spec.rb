require 'spec_helper'

describe Dox::Printers::ExamplePrinter do
  subject { described_class }

  let(:content_type) { 'application/json' }
  let(:response) { double('response', content_type: content_type, status: 200, body: nil) }
  let(:request) { double('request', content_type: content_type, query_parameters: {}, path_parameters: {}) }
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
      let(:request_header_output) do
        <<~HEREDOC

        + Request Returns a Pokemon (application/json)
        HEREDOC
      end

      let(:response_header_output) do
        <<~HEREDOC
        + Response 200 (application/json)
        HEREDOC
      end

      before { printer.print(example) }

      it { expect(output).to have_received(:puts).twice }
      it { expect(output).to have_received(:puts).with(request_header_output.rstrip).once }
      it { expect(output).to have_received(:puts).with(response_header_output.strip).once }
    end

    context 'with request parameters and response body' do
      let(:response_body) { { id: 1, name: 'Pikachu' }.to_json }
      let(:body_parameters) { { 'name' => 'Pikachu', type: 'Electric' } }

      # indentation matters here
      let(:response_body_output) do
        <<-HEREDOC

        {
          "id": 1,
          "name": "Pikachu"
        }
        HEREDOC
      end

      let(:request_body_output) do
        <<-HEREDOC

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

      it { expect(output).to have_received(:puts).exactly(4).times }
      it { expect(output).to have_received(:puts).with(request_body_output).once }
      it { expect(output).to have_received(:puts).with(response_body_output).once }
    end

    context 'with empty string as a body' do
      before do
        allow(response).to receive(:body).and_return('')
      end

      before { printer.print(example) }
      it { expect(output).to have_received(:puts).exactly(2).times }
    end
  end
end
