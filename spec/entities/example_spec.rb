describe Dox::Entities::Example do
  subject { described_class }

  let(:response_body) { { hello: 'world' }.to_json }
  let(:content_type) { { content_type: 'application/json' } }
  let(:example_desc) { 'Dummy' }
  let(:query_params) { { 'color' => 'blue'} }
  let(:path_params) { { 'id' => 11 } }
  let(:body_parameters) { { 'data' => 'users' } }

  let(:response) { double('response', content_type: content_type, status: 200, body: response_body) }
  let(:request) { double('request', content_type: content_type, query_parameters: query_params, path_parameters: path_params) }

  let(:example) { subject.new({ description: example_desc }, request, response) }

  describe '#request_parameters' do
    context 'with query and path parameters only' do
      before { allow(request).to receive(:parameters).and_return(query_params.merge(path_params)) }

      it 'returns empty request parameters' do
        expect(example.request_parameters).to eq({})
      end
    end

    context 'with body paramaters too' do
      before { allow(request).to receive(:parameters).and_return(query_params.merge(path_params).merge(body_parameters)) }

      it 'returns request body parameters' do
        expect(example.request_parameters).to eq(body_parameters)
      end
    end
  end

  describe '#request_content_type' do
    it { expect(example.request_content_type).to eq(content_type) }
  end

  describe '#request_identifier' do
    it { expect(example.request_identifier).to eq(example_desc) }
  end

  describe '#response_content_type' do
    it { expect(example.response_content_type).to eq(content_type) }
  end

  describe '#response_status' do
    it { expect(example.response_status).to eq(response.status) }
  end

  describe '#response_body' do
    it { expect(example.response_body).to eq(response_body) }
  end
end
