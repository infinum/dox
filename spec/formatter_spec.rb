describe Dox::Formatter do
  subject { described_class }

  let(:output) { StringIO.new }

  context 'with required methods' do
    it 'has example_started method' do
      expect(subject.method_defined?(:example_started)).to eq(true)
    end

    it 'has example_passed method' do
      expect(subject.method_defined?(:example_started)).to eq(true)
    end

    it 'has stop method' do
      expect(subject.method_defined?(:stop)).to eq(true)
    end
  end

  context 'with passed examples' do
    let(:formatter) { subject.new(output) }
    let(:header_filepath) { 'api_header_demo.md' }

    before do
      # allow(output).to receive(:puts)

      allow(Dox).to receive_message_chain(:config, :header_file_path).and_return(header_filepath)
      allow(Dox).to receive_message_chain(:config, :desc_folder_path).and_return(Pathname.new('/Users/someuser'))
    end

    let(:pokemon_request) do
      double(:pokemon_request, method: 'POST', path: '/pokemons', path_parameters: {}, content_type: 'json', request_parameters: {}, parameters: {}, query_parameters: {} )
    end

    let(:pokemon_response) do
      double(:pokemon_response, status: 201, content_type: 'json', body: {}.to_json )
    end

    let(:pokemon_meta) do
      {
        resource_group_name: 'Pokemons',
        resource_group_desc: 'Hello',
        resource_name: 'Pokemons',
        resource_endpoint: '/pokemons',
        action_name: 'Create pokemon',
        apidoc: true
      }
    end

    let(:pokemon_instance) do
      double(:pokemon_instance, request: pokemon_request, response: pokemon_response)
    end

    let(:pokemon_meta_d) { double(:pokemon_meta, metadata: pokemon_meta, example_group_instance: pokemon_instance) }
    let(:create_pokemon) do
      double(:create_pokemon, example: pokemon_meta_d)
    end

    # let(:get_pokemons) do
    #   double(:get_pokemons)
    # end
    #
    # let(:get_pokemons) do
    #   double(:get_pokemons)
    # end
    #
    # let(:get_digimon) do
    #   double(:get_digimon)
    # end

    let(:expected_output) { File.read('spec/fixtures/example.md') }

    before do
      formatter.example_started(create_pokemon)
      formatter.example_passed(create_pokemon)
      formatter.stop(nil)
    end

    it 'prints whole doc' do
      expect(output.string).to eq(expected_output)
    end
  end
end
