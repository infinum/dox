require_relative 'fixtures/dox_test_classes'

describe Dox::Formatter do
  include DirectoryHelper
  include OutputHelper

  subject { described_class }

  let(:docs_output) { StringIO.new }
  let(:formatter) { subject.new(docs_output) }

  let(:get_pokemon_data) do
    {
      meta: {
        apidoc: true,
        dox: true,
        resource_group_name: 'Pokemons & Digimons',
        resource_name: 'Pokemons',
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
          data: {
            pokemon: {
              id: 14,
              name: 'Pikachu',
              type: 'electric'
            }
          }
        },
        headers: { 'Content-Type' => 'application/json' }
      }
    }
  end

  let(:create_pokemon_data) do
    {
      meta: {
        apidoc: true,
        dox: true,
        resource_group_name: 'Pokemons & Digimons',
        resource_name: 'Pokemons',
        action_name: 'Create pokemon',
        description: 'creates pokemon'
      },
      request: {
        method: 'POST',
        path: '/pokemons',
        fullpath: '/pokemons?name=Pikachu&type=Electric',
        body: {
          data: {
            pokemon: {
              name: 'Pikachu',
              type: 'electric'
            }
          }
        },
        headers: { 'Accept' => 'application/json' }
      },
      response: {
        status: 201,
        body: {
          data: {
            pokemon: {
              id: 1,
              name: 'Pikachu',
              type: 'electric'
            }
          }
        },
        headers: { 'Content-Type' => 'application/json' }
      }
    }
  end

  let(:get_digimons_data) do
    {
      meta: {
        apidoc: true,
        dox: true,
        resource_group_name: 'Pokemons & Digimons',
        resource_name: 'Digimons',
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
        body: {
          data: [
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
          ]
        },
        headers: { 'Content-Type' => 'application/json' }
      }
    }
  end

  let(:get_auth_data) do
    {
      meta: {
        apidoc: true,
        dox: true,
        resource_group_name: 'Auth',
        resource_name: 'Auth',
        action_name: 'Auth',
        action_desc: 'Auth',
        description: 'Auth'
      },
      request: {
        method: 'get',
        path: '/auth',
        fullpath: '/auth',
        headers: { 'Accept' => 'application/json' }
      },
      response: {
        status: 200,
        body: {
          data: {
            user: {
              id: 11,
              name: 'Me'
            }
          }
        },
        headers: { 'Content-Type' => 'application/json' }
      }
    }
  end

  context 'skipped examples' do
    let(:printer) { instance_double(Dox::Printers::DocumentPrinter, print: nil) }
    let(:example_group) { RSpec::Core::ExampleGroup.describe('Pokemon', meta) }
    let(:example) do
      instance_double(RSpec::Core::Example, example_group_instance: example_group,
                                            metadata: meta)
    end
    let(:notification) do
      instance_double(RSpec::Core::Notifications::ExampleNotification, example: example)
    end
    let(:stop_notification) do
      instance_double(RSpec::Core::Notifications::ExamplesNotification, examples: [example], failed_examples: [])
    end

    before do
      allow(Dox::Printers::DocumentPrinter).to receive(:new).and_return(printer)

      formatter.example_passed(notification)

      formatter.stop(stop_notification)
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

  context 'with all passed examples' do
    let(:config) do
      instance_double(Dox::Config, descriptions_location: fixtures_path.join('someuser'),
                                   schema_request_folder_path: File.join(fixtures_path, '../schemas'),
                                   schema_response_folder_path: File.join(fixtures_path, '../schemas'),
                                   openapi_version: '3.0.0',
                                   groups_order: ['Pokemons & Digimons', 'Auth'],
                                   title: 'Header demo',
                                   header_description: 'Test demo',
                                   api_version: '2.0',
                                   headers_whitelist: nil)
    end

    before do
      allow(Dox).to receive(:config).and_return(config)
    end

    let(:create_pokemon) { DoxTestNotification.new(create_pokemon_data) }
    let(:get_pokemon) { DoxTestNotification.new(get_pokemon_data) }
    let(:get_digimons) { DoxTestNotification.new(get_digimons_data) }
    let(:get_auth) { DoxTestNotification.new(get_auth_data) }

    let(:stop_notification) do
      instance_double(RSpec::Core::Notifications::ExamplesNotification,
                      examples: [create_pokemon, get_pokemon, get_digimons],
                      failed_examples: [])
    end

    before do
      formatter.example_passed(create_pokemon)
      formatter.example_passed(get_pokemon)
      formatter.example_passed(get_digimons)
      formatter.example_passed(get_auth)

      formatter.stop(stop_notification)
    end

    it 'prints whole doc' do
      expect(docs_output.string).to eq(example_output)
    end
  end

  context 'with passed and failed examples' do
    let(:get_pokemon) { DoxTestNotification.new(get_pokemon_data) }
    let(:create_pokemon) { DoxTestNotification.new(create_pokemon_data) }

    let(:stop_notification) do
      instance_double(RSpec::Core::Notifications::ExamplesNotification,
                      examples: [get_pokemon],
                      failed_examples: [create_pokemon],
                      fully_formatted_failed_examples: 'failed examples dump')
    end

    before do
      formatter.example_passed(get_pokemon)
    end

    it 'prints failure details to stderr' do
      expect { formatter.stop(stop_notification) }.to output("failed examples dump\n").to_stderr
    end

    it 'does not print anything to docs output' do
      formatter.stop(stop_notification)
      expect(docs_output.string).to be_empty
    end
  end
end
