describe Dox::Formatters::Json do
  subject { described_class.new(http_env).format }

  let(:http_env) { double(:request_or_response, body: body) }

  describe '#format' do
    context 'when valid JSON' do
      let(:body) do
        {
          data: {
            attributes: {
              name: 'John Doe'
            }
          }
        }.to_json
      end
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

      it { is_expected.to eq formatted_response }
    end

    context 'when body is nil' do
      let(:body) { nil }
      let(:formatted_response) { '' }

      it { is_expected.to eq formatted_response }
    end

    context 'when body length less than 2' do
      let(:body) { '{' }
      let(:formatted_response) { '' }

      it { is_expected.to eq formatted_response }
    end
  end
end
