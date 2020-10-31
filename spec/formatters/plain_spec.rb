describe Dox::Formatters::Plain do
  subject { described_class.new(http_env).format }

  let(:http_env) { double(:request_or_response, body: body) }

  describe '#format' do
    context 'when encoding UTF_8' do
      let(:body) { 'body' }

      it { is_expected.to eq 'body' }
    end

    context 'when encoding not UTF_8' do
      let(:body) { 'hi™!'.encode('Windows-1252') }

      it { is_expected.to eq 'hi™!' }
    end

    context 'when conversion fails' do
      let(:body) { 0x8f.chr }

      it { is_expected.to eq 'ASCII-8BIT stream' }
    end
  end
end
