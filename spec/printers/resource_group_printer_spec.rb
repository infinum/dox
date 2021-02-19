describe Dox::Printers::ResourceGroupPrinter do
  subject { described_class }

  let(:details) do
    {
      resource_group_name: 'Pokemons',
      resource_group_desc: 'Pokemons desc'
    }
  end
  let(:resource_group) { Dox::Entities::ResourceGroup.new(details) }

  let(:hash) do
    { 'x-tagGroups' => [] }
  end
  let(:printer) { described_class.new(hash) }

  describe '#print' do
    it 'prints resource group header' do
      printer.print(resource_group)
      hash['x-tagGroups'][0] = resource_group.name
    end

    context 'with one resource' do
      let(:resource_details) do
        {
          resource_name: 'Pokemons',
          resource_desc: 'Pokemons'
        }
      end
      let(:resource) { Dox::Entities::Resource.new(resource_details) }

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
