describe Dox::Formatters::Multipart do
  subject { described_class.new(http_env).format }

  let(:http_env) { double(:request_or_response, body: body) }

  describe '#format' do
    let(:body) { File.open('spec/fixtures/example.json') }
    let(:formatted_response) do
      <<~HEREDOC.chomp
        {
          "data": {
            "attributes": {
              "name": "John Doe"
            }
          }
        }
      HEREDOC
    end

    before do
      allow(Rack::Multipart).to receive(:extract_multipart).and_return(formatted_response)
    end

    it { is_expected.to eq JSON.pretty_generate(formatted_response) }

    it 'uses Rack::Multipart' do
      subject

      expect(Rack::Multipart).to have_received(:extract_multipart).once
    end
  end
end
