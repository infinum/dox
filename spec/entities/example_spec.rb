describe Dox::Entities::Example do
  subject { described_class }

  let(:response_body) { { hello: 'world' }.to_json }
  let(:content_type) { { content_type: 'application/json' } }
  let(:example_desc) { 'Dummy' }
  let(:query_params) { { 'color' => 'blue'} }
  let(:path_params) { { 'id' => 11 } }
  let(:body) { { 'data' => 'users' } }
  let(:body_query) { 'data=users' }
  let(:request_fullpath) { '/pokemons?color=blue' }

  let(:response) { double('response', content_type: content_type, status: 200, body: response_body) }
  let(:request) { double('request', content_type: content_type, query_parameters: query_params, path_parameters: path_params, path: '/pokemons') }

  let(:example) { subject.new({ description: example_desc }, request, response) }

  describe '#request_body' do
    context 'when empty' do
      before { allow(request).to receive(:body).and_return(StringIO.new) }

      it { expect(example.request_body).to eq('') }
    end

    context 'when present' do
      before { allow(request).to receive(:body).and_return(StringIO.new(body.to_json)) }

      it { expect(example.request_body).to eq(body) }
    end

    context 'when body_format is :query' do
      before { Dox.configure{ |c| c.body_format = :query } }
      before { allow(request).to receive(:body).and_return(StringIO.new(body_query)) }
      after { Dox.configure{ |c| c.body_format = :json } }

      it { expect(example.request_body).to eq(body_query) }
    end
  end

  describe '#request_content_type' do
    it { expect(example.request_content_type).to eq(content_type) }
  end

  describe '#request_identifier' do
    it { expect(example.request_identifier).to eq(example_desc) }
  end

  describe '#request_fullpath' do
    it { expect(example.request_fullpath).to eq(request_fullpath) }

    context 'multiple query params' do
      let(:query_params) { { 'color' => 'blue', 'power' => '100' } }
      let(:request_fullpath) { '/pokemons?color=blue&power=100' }

      it { expect(example.request_fullpath).to eq(request_fullpath) }
    end

    context 'query params with special characters' do
      let(:query_params) { { 'color' => 'blue', 'power' => '100/50' } }
      let(:request_fullpath) { '/pokemons?color=blue&power=100/50' }

      it { expect(example.request_fullpath).to eq(request_fullpath) }
    end

    context 'without query params' do
      let(:query_params) { {} }
      let(:request_fullpath) { '/pokemons' }

      it { expect(example.request_fullpath).to eq(request_fullpath) }
    end
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
