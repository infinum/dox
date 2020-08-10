describe Dox::Entities::Resource do
  subject { described_class }

  let(:details) do
    {
      resource_name: 'Pokemons',
      resource_desc: 'Pokemons',
      resource_endpoint: '/pokemons'
    }
  end

  let(:resource) { subject.new(details) }

  describe '#name' do
    it { expect(resource.name).to eq(details[:resource_name]) }
  end

  describe '#desc' do
    it { expect(resource.desc).to eq(details[:resource_desc]) }
  end

  describe '#endpoint' do
    it { expect(resource.endpoint).to eq(details[:resource_endpoint]) }
  end

  describe '#actions' do
    it { expect(resource.actions).to eq({}) }
  end
end
