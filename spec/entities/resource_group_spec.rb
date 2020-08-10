describe Dox::Entities::ResourceGroup do
  subject { described_class }

  let(:details) do
    {
      resource_group_name: 'Pokemons',
      resource_group_desc: 'Pokemons'
    }
  end

  let(:resource_group) { subject.new(details) }

  describe '#name' do
    it { expect(resource_group.name).to eq(details[:resource_group_name]) }
  end

  describe '#desc' do
    it { expect(resource_group.desc).to eq(details[:resource_group_desc]) }
  end

  describe '#resources' do
    it { expect(resource_group.resources).to eq({}) }
  end
end
