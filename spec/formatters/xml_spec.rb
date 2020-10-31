describe Dox::Formatters::Xml do
  subject { described_class.new(http_env).format.chomp }

  let(:http_env) { double(:request_or_response, body: body) }

  describe '#format' do
    let(:body) do
      <<~HEREDOC
        <?xml version='1.0' encoding='ISO-8859-15'?>
        <node>
          <subnode>
            <object>
              <attribute1>sample_value</attribute1>
              <attribute2>sample_value</attribute2>
            </object>
          </subnode>
        </node>
      HEREDOC
    end

    it { is_expected.to eq body.chomp }
  end
end
