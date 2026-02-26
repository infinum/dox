RSpec.describe Dox::HtmlRenderer do
  include DirectoryHelper

  let(:output_dir) { Dir.mktmpdir('dox_test') }
  let(:output_path) { File.join(output_dir, 'index.html') }
  let(:config) do
    instance_double(Dox::Config, title: 'Fallback Title', redoc_version: nil)
  end

  before do
    allow(Dox).to receive(:config).and_return(config)
  end

  after do
    FileUtils.rm_rf(output_dir)
  end

  describe '#render' do
    context 'with a custom adapter' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec_no_title.json').to_s }
      let(:adapter) { instance_double(Dox::RedoclyAdapter) }
      let(:renderer) { described_class.new(spec_path, output_path, adapter: adapter) }

      it 'delegates html generation to the adapter and writes the result' do
        allow(adapter).to receive(:build_html).and_return('<html>custom</html>')

        renderer.render

        expect(File.read(output_path)).to eq('<html>custom</html>')
        expect(adapter).to have_received(:build_html).with('Fallback Title', hash_including('openapi' => '3.0.0'))
      end
    end

    context 'with nested file $ref references' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }
      let(:html) { File.read(output_path) }
      let(:parsed_spec) { extract_spec_from_html(html) }

      before { renderer.render }

      it 'resolves the full $ref chain (apispec → item.json → category.json)', :aggregate_failures do
        schema = parsed_spec.dig('paths', '/items', 'get', 'responses', '200',
                                 'content', 'application/json', 'schema')

        expect(schema['type']).to eq('object')
        expect(schema['properties']).to have_key('id')
        expect(schema['properties']).to have_key('name')

        category = schema.dig('properties', 'category')
        expect(category['type']).to eq('object')
        expect(category['properties']).to have_key('name')
        expect(category['required']).to eq(['name'])
      end

      it 'does not leave file path refs in the output' do
        expect(html).not_to include('schemas/item.json')
        expect(html).not_to include('shared/category.json')
      end
    end

    context 'with internal $ref references in the top-level spec' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec_internal_refs.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }

      before { renderer.render }

      it 'preserves them for Redoc to resolve at render time' do
        html = File.read(output_path)

        expect(html).to include('#/definitions/relationship_properties')
      end
    end

    context 'with an external file that has internal $ref references' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec_external_with_internal_refs.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }

      before { renderer.render }

      it 'resolves internal #/ pointers from the inlined file', :aggregate_failures do
        parsed_spec = extract_spec_from_html(File.read(output_path))
        data = parsed_spec.dig('paths', '/relationships', 'get', 'responses', '200',
                               'content', 'application/json', 'schema', 'properties', 'data')

        expect(data['properties']).to have_key('id')
        expect(data['properties']).to have_key('type')
        expect(data['required']).to eq(['id', 'type'])
      end
    end

    context 'title' do
      it 'uses the title from the spec' do
        spec_path = fixtures_path.join('html_renderer', 'apispec.json').to_s
        described_class.new(spec_path, output_path).render

        expect(File.read(output_path)).to include('<title>Test API</title>')
      end

      it 'falls back to the configured title when the spec has none' do
        spec_path = fixtures_path.join('html_renderer', 'apispec_no_title.json').to_s
        described_class.new(spec_path, output_path).render

        expect(File.read(output_path)).to include('<title>Fallback Title</title>')
      end
    end

    context 'redoc version' do
      it 'defaults to 2.5.1' do
        spec_path = fixtures_path.join('html_renderer', 'apispec.json').to_s
        described_class.new(spec_path, output_path).render

        expect(File.read(output_path)).to include('redoc/v2.5.1/bundles/redoc.standalone.js')
      end

      it 'uses the configured version' do
        allow(config).to receive(:redoc_version).and_return('2.4.0')
        spec_path = fixtures_path.join('html_renderer', 'apispec.json').to_s
        described_class.new(spec_path, output_path).render

        expect(File.read(output_path)).to include('redoc/v2.4.0/bundles/redoc.standalone.js')
      end
    end

    context 'when the output directory does not exist' do
      it 'creates it' do
        spec_path = fixtures_path.join('html_renderer', 'apispec.json').to_s
        nested_path = File.join(output_dir, 'deep', 'nested', 'index.html')
        described_class.new(spec_path, nested_path).render

        expect(File.exist?(nested_path)).to be true
      end
    end
  end

  def extract_spec_from_html(html)
    match = html.match(/Redoc\.init\((.+),\s*\{\},/)
    JSON.parse(match[1])
  end
end
