describe Dox::Printers::DocumentPrinter do
  include DirectoryHelper
  include OutputHelper

  subject { described_class }

  let(:passed_example) { double(:passed_example) }
  let(:output) { double(:output) }
  let(:printer) { subject.new(output) }
  let(:schema_request_folder_path) { File.join(File.dirname(__FILE__), '../schemas') }
  let(:config) do
    instance_double(Dox::Config, descriptions_location: fixtures_path.join('someuser'),
                                 schema_request_folder_path: schema_request_folder_path,
                                 schema_response_folder_path: File.join(fixtures_path, '../schemas'),
                                 openapi_version: '3.0.0',
                                 title: 'Header demo',
                                 header_description: 'Test demo',
                                 api_version: '2.0',
                                 headers_whitelist: nil)
  end

  before do
    allow(output).to receive(:puts)

    allow(Dox).to receive(:config).and_return(config)
  end

  describe '#print' do
    context 'without passed_examples' do
      before { printer.print({}) }
      it do
        expect(output).to have_received(:puts).with(api_header_demo_output[0...-1])
      end
    end

    context 'with one passed_example' do
      let(:group_printer) { double(:group_printer) }
      before do
        expect_any_instance_of(Dox::Printers::ResourceGroupPrinter).to receive(:print).once
      end

      it { printer.print(example1: passed_example) }
    end
  end
end
