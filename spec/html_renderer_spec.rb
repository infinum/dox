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
    context 'with nested $ref references' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }
      let(:html) { File.read(output_path) }

      before { renderer.render }

      it 'generates an HTML file at the output path' do
        expect(File.exist?(output_path)).to be true
      end

      it 'uses the title from the spec' do
        expect(html).to include('<title>Test API</title>')
      end

      it 'includes the Redoc script tag with default version' do
        expect(html).to include('redoc/v2.5.1/bundles/redoc.standalone.js')
      end

      it 'resolves all $ref references' do
        expect(html).not_to include('$ref')
      end

      it 'resolves first-level $ref (item schema)', :aggregate_failures do
        parsed_spec = extract_spec_from_html(html)
        schema = parsed_spec.dig('paths', '/items', 'get', 'responses', '200',
                                 'content', 'application/json', 'schema')

        expect(schema['type']).to eq('object')
        expect(schema['properties']).to have_key('id')
        expect(schema['properties']).to have_key('name')
      end

      it 'resolves second-level $ref (category schema nested inside item)', :aggregate_failures do
        parsed_spec = extract_spec_from_html(html)
        category = parsed_spec.dig('paths', '/items', 'get', 'responses', '200',
                                   'content', 'application/json', 'schema',
                                   'properties', 'category')

        expect(category['type']).to eq('object')
        expect(category['properties']).to have_key('name')
        expect(category['required']).to eq(['name'])
      end

      it 'produces valid HTML structure', :aggregate_failures do
        expect(html).to include('<!DOCTYPE html>')
        expect(html).to include('<div id="redoc"></div>')
        expect(html).to include('Redoc.init(')
      end
    end

    context 'when the spec has no title' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec_no_title.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }

      before { renderer.render }

      it 'falls back to the configured title' do
        html = File.read(output_path)

        expect(html).to include('<title>Fallback Title</title>')
      end
    end

    context 'with a custom redoc version' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec.json').to_s }
      let(:renderer) { described_class.new(spec_path, output_path) }

      let(:config) do
        instance_double(Dox::Config, title: 'My API', redoc_version: '2.4.0')
      end

      before { renderer.render }

      it 'uses the configured redoc version' do
        html = File.read(output_path)

        expect(html).to include('redoc/v2.4.0/bundles/redoc.standalone.js')
      end
    end

    context 'when the output directory does not exist' do
      let(:spec_path) { fixtures_path.join('html_renderer', 'apispec.json').to_s }
      let(:nested_output_path) { File.join(output_dir, 'deep', 'nested', 'index.html') }
      let(:renderer) { described_class.new(spec_path, nested_output_path) }

      before { renderer.render }

      it 'creates the directory and writes the file' do
        expect(File.exist?(nested_output_path)).to be true
      end
    end
  end

  private

  def extract_spec_from_html(html)
    match = html.match(/Redoc\.init\((.+),\s*\{\},/)
    JSON.parse(match[1])
  end
end
