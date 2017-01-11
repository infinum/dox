describe Dox::Printers::ResourceGroupPrinter do
  subject { described_class }

  let(:details) do
    {
      resource_group_desc: 'Pokemons desc'
    }
  end
  let(:resource_group) { Dox::Entities::ResourceGroup.new('Pokemons', details) }

  let(:output) { double(:output) }
  let(:printer) { described_class.new(output) }

  describe '#print' do
    let(:resource_group_output) do
      <<~HEREDOC

        # Group Pokemons
        Pokemons desc
      HEREDOC
    end

    before do
      allow(output).to receive(:puts)
    end

    it 'prints resource group header' do
      printer.print(resource_group)
      expect(output).to have_received(:puts).with(resource_group_output)
    end

    context 'with one resource' do
      let(:resource_details) do
        {
          resource_desc: 'Pokemons',
          resource_endpoint: '/pokemons',
        }
      end
      let(:resource) { Dox::Entities::Resource.new('Pokemons', resource_details) }

      before do
        resource_group.resources[resource.name] = resource

        expect_any_instance_of(Dox::Printers::ResourcePrinter).to receive(:print).once
      end

      it 'triggers resource printer once' do
        printer.print(resource_group)
      end
    end
  end
end
