describe Dox::Entities::Resource do
  subject { described_class }

  let(:resource_name) { 'Pokemons' }
  let(:details) do
    {
      resource_desc: 'Pokemons',
      resource_endpoint: '/pokemons',
    }
  end

  let(:resource) { subject.new(resource_name, details) }

  describe '#name' do
    it { expect(resource.name).to eq(resource_name) }
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
