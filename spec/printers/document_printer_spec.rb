describe Dox::Printers::DocumentPrinter do
  subject { described_class }

  let(:passed_example) { double(:passed_example) }
  let(:output) { double(:output) }
  let(:printer) { subject.new(output) }
  let(:header_filepath) { 'api_header_demo.md' }

  before do
    allow(output).to receive(:puts)

    allow(Dox).to receive_message_chain(:config, :header_file_path).and_return(header_filepath)
    allow(Dox).to receive_message_chain(:config, :desc_folder_path).and_return(Pathname.new('/Users/someuser'))
  end

  describe '#print' do
    context 'without passed_examples' do
      before { printer.print({}) }
      it { expect(output).to have_received(:puts).with('<!-- include(/Users/someuser/api_header_demo.md) -->') }
    end

    context 'with one passed_example' do
      let(:group_printer) { double(:group_printer) }
      before do
        expect_any_instance_of(Dox::Printers::ResourceGroupPrinter).to receive(:print).once
      end

      it { printer.print({ example1: passed_example }) }
    end
  end

end
