require_relative 'fixtures/dox_test_classes'

describe Dox::Formatter do
  include DirectoryHelper
  include OutputHelper

  subject { described_class }

  let(:output) { StringIO.new }

  context 'skipped examples' do
    let(:printer) { instance_double(Dox::Printers::DocumentPrinter, print: nil) }
    let(:formatter) { subject.new(output) }
    let(:example_group) { RSpec::Core::ExampleGroup.describe('Pokemon', meta) }
    let(:example) do
      instance_double(RSpec::Core::Example, example_group_instance: example_group,
                                            metadata: meta)
    end
    let(:notification) do
      instance_double(RSpec::Core::Notifications::ExampleNotification, example: example)
    end

    before do
      allow(Dox::Printers::DocumentPrinter).to receive(:new).and_return(printer)

      formatter.example_passed(notification)

      formatter.stop(nil)
    end

    context 'tagged with nodoc' do
      let(:meta) { { apidoc: true, dox: true, nodoc: true } }

      it 'skips examples' do
        expect(printer).to have_received(:print).with({})
      end
    end

    context 'without dox tag' do
      let(:meta) { { apidoc: true } }

      it 'skips examples' do
        expect(printer).to have_received(:print).with({})
      end
    end
  end

  context 'with passed examples' do
    let(:formatter) { subject.new(output) }
    let(:header_filepath) { 'api_header_demo.md' }
    let(:config) do
      instance_double(Dox::Config, header_file_path: header_filepath,
                                   desc_folder_path: fixtures_path.join('someuser'),
                                   headers_whitelist: nil,
                                   body_format: :json)
    end

    before do
      allow(Dox).to receive(:config).and_return(config)
    end

    let(:create_pokemon_data) do
      {
        meta: {
          apidoc: true,
          dox: true,
          resource_group_name: 'Pokemons & Digimons',
          resource_group_desc: 'Pokemons desc',
          resource_name: 'Pokemons',
          resource_endpoint: '/pokemons',
          action_name: 'Create pokemon',
          description: 'creates pokemon'
        },
        request: {
          method: 'POST',
          path: '/pokemons',
          fullpath: '/pokemons?name=Pikachu&type=Electric',
          body: {
            pokemon: {
              name: 'Pikachu',
              type: 'electric'
            }
          },
          headers: { 'Content-Type' => 'application/json' }
        },
        response: {
          status: 201,
          body: {
            pokemon: {
              id: 1,
              name: 'Pikachu',
              type: 'electric'
            }
          },
          headers: { 'Content-Type' => 'application/json' }
        }
      }
    end

    let(:create_pokemon) do
      DoxTestNotification.new(create_pokemon_data)
    end

    let(:get_pokemon_data) do
      {
        meta: {
          apidoc: true,
          dox: true,
          resource_group_name: 'Pokemons & Digimons',
          resource_name: 'Pokemons',
          resource_endpoint: '/pokemons',
          action_name: 'Get pokemon',
          description: 'returns pokemon'
        },
        request: {
          method: 'get',
          path: '/pokemons/14',
          fullpath: '/pokemons/14',
          path_parameters: { id: 14 },
          headers: { 'Accept' => 'application/json' }
        },
        response: {
          status: 200,
          body: {
            pokemon: {
              id: 14,
              name: 'Pikachu',
              type: 'electric'
            }
          },
          headers: { 'Content-Type' => 'application/json' }
        }
      }
    end

    let(:get_pokemon) do
      DoxTestNotification.new(get_pokemon_data)
    end

    let(:get_digimons_data) do
      {
        meta: {
          apidoc: true,
          dox: true,
          resource_group_name: 'Pokemons & Digimons',
          resource_name: 'Digimons',
          resource_desc: 'Digimons desc',
          resource_endpoint: '/digimons',
          action_name: 'Get digimons',
          action_desc: 'Returns all digimons',
          description: 'returns digimons'
        },
        request: {
          method: 'get',
          path: '/digimons',
          fullpath: '/digimons',
          headers: { 'Accept' => 'application/json' }
        },
        response: {
          status: 200,
          body: [
            {
              digimon: {
                id: 11,
                name: 'Tanemon',
                type: 'Bulb'
              }
            },
            {
              digimon: {
                id: 12,
                name: 'Pyocomon',
                type: 'Bulb'
              }
            }
          ],
          headers: { 'Content-Type' => 'application/json' }
        }
      }
    end

    let(:get_digimons) do
      DoxTestNotification.new(get_digimons_data)
    end

    before do
      formatter.example_passed(create_pokemon)
      formatter.example_passed(get_pokemon)
      formatter.example_passed(get_digimons)

      formatter.stop(nil)
    end

    it 'prints whole doc' do
      expect(output.string).to eq(example_output)
    end
  end
end
