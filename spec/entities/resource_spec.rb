describe Dox::Entities::Resource do
  subject { described_class }

  let(:details) do
    {
      resource_name: 'Pokemons',
      resource_desc: 'Pokemons'
    }
  end

  let(:resource) { subject.new(details) }

  describe '#name' do
    it { expect(resource.name).to eq(details[:resource_name]) }
  end

  describe '#desc' do
    it { expect(resource.desc).to eq(details[:resource_desc]) }
  end

  describe '#actions' do
    it { expect(resource.actions).to eq({}) }
  end
end
