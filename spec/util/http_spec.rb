RSpec.describe Dox::Util::Http do
  describe '.verb?' do
    it 'checks for valid HTTP verbs' do
      stub_const('Dox::Util::Http::VERB', ['VERB'])

      expect(described_class.verb?('invalid')).to eq(false)
    end
  end
end
