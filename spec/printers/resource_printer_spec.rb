describe Dox::Printers::ResourcePrinter do
  subject { described_class }

  let(:details) do
    {
      resource_desc: 'Pokemons',
      resource_endpoint: '/pokemons',
    }
  end
  let(:resource) { Dox::Entities::Resource.new('Pokemons', details) }

  let(:output) { double(:output) }
  let(:printer) { described_class.new(output) }

  before do
    allow(Rails).to receive_message_chain(:root, :join).and_return('/')
  end

  describe '#print' do
    let(:resource_output) do
      <<~HEREDOC

        ## Pokemons [/pokemons]

        Pokemons
      HEREDOC
    end

    before do
      allow(output).to receive(:puts)
    end

    it 'prints resource header' do
      printer.print(resource)
      expect(output).to have_received(:puts).with(resource_output)
    end

    context 'with two actions' do
      let(:request) { double(:request, method: 'GET', path_parameters: {}, path: '/pokemons') }
      let(:action1) { Dox::Entities::Action.new('Get Pokemons 1', {}, request) }
      let(:action2) { Dox::Entities::Action.new('Get Pokemons 2', {}, request) }

      before do
        resource.actions[action1.name] = action1
        resource.actions[action2.name] = action2

        expect_any_instance_of(Dox::Printers::ActionPrinter).to receive(:print).twice
      end

      it 'triggers action printer twice' do
        printer.print(resource)
      end
    end
  end
end
