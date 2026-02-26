RSpec.describe Dox::RedoclyAdapter do
  let(:config) do
    instance_double(Dox::Config, title: 'Fallback Title', redoc_version: nil)
  end
  let(:adapter) { described_class.new }
  let(:spec) { { 'openapi' => '3.0.0', 'paths' => {} } }

  before do
    allow(Dox).to receive(:config).and_return(config)
  end

  describe '#build_html' do
    it 'renders html with title and serialized spec', :aggregate_failures do
      html = adapter.build_html('Test API', spec)

      expect(html).to include('<title>Test API</title>')
      expect(html).to include("Redoc.init(#{JSON.generate(spec)}, {},")
    end

    it 'defaults to redoc version 2.5.1' do
      html = adapter.build_html('Test API', spec)

      expect(html).to include('redoc/v2.5.1/bundles/redoc.standalone.js')
    end

    it 'uses the configured redoc version' do
      allow(config).to receive(:redoc_version).and_return('2.4.0')

      html = adapter.build_html('Test API', spec)

      expect(html).to include('redoc/v2.4.0/bundles/redoc.standalone.js')
    end
  end
end
