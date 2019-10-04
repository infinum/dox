describe Dox::Printers::ResourcePrinter do
  subject { described_class }

  let(:details) do
    {
      resource_name: 'Pokemons',
      resource_desc: 'pokemons.md',
      resource_endpoint: '/pokemons',
      resource_group_name: 'Beings'
    }
  end
  let(:resource) { Dox::Entities::Resource.new(details) }

  let(:hash) do
    { 'x-tagGroups' => [name: resource.group, 'tags' => []], 'tags' => [] }
  end
  let(:printer) { described_class.new(hash) }

  describe '#print' do
    before { Dox.config.desc_folder_path = File.join(File.dirname(__FILE__), '../fixtures/someuser') }
    it 'prints resource header' do
      printer.print(resource)

      expect(hash['x-tagGroups'][0]['tags'][0] == resource.name)
      expect(hash['tags'][0][:name] == resource.name)
      expect(hash['tags'][0]['description'] == File.read(File.join(Dox.config.desc_folder_path, resource.desc)))
    end

    context 'with two actions' do
      let(:request) { double(:request, method: 'GET', path_parameters: {}, path: '/pokemons') }
      let(:action1) { Dox::Entities::Action.new({ action_name: 'Get Pokemons 1' }, request) }
      let(:action2) { Dox::Entities::Action.new({ action_name: 'Get Pokemons 2' }, request) }

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
