require_relative 'fixtures/dox_dsl_test_classes'

describe Dox::DSL::Documentation do
  describe '.api' do
    let(:expected_output) do
      {
        apidoc: true,
        resource_desc: nil,
        resource_endpoint: '/pokemons',
        resource_group_desc: 'Pokemons group desc',
        resource_group_name: 'Pokemons',
        resource_name: 'Pokemons'
      }
    end

    it 'adds metadata to test' do
      expect(DocApiExample.metadata).to eq(expected_output)
    end
  end

  describe '.action' do
    context 'with minimal action params' do
      let(:expected_output) do
        {
          apidoc: true,
          resource_desc: nil,
          resource_endpoint: '/pokemons',
          resource_group_desc: 'Pokemons group desc',
          resource_group_name: 'Pokemons',
          resource_name: 'Pokemons',
          action_name: 'Get Pokemons',
          action_request_schema: nil,
          action_response_schema_success: nil,
          action_response_schema_fail: nil,
          action_verb: nil,
          action_desc: '',
          action_path: nil,
          action_params: nil,
          action_query_params: []
        }
      end

      it 'adds metadata to test' do
        expect(DoxActionIndexExample.metadata).to match(expected_output)
      end
    end

    context 'with all action params' do
      let(:expected_output) do
        {
          apidoc: true,
          resource_desc: nil,
          resource_endpoint: '/pokemons',
          resource_group_desc: 'Pokemons group desc',
          resource_group_name: 'Pokemons',
          resource_name: 'Pokemons',
          action_name: 'Get Pokemon',
          action_verb: 'GET',
          action_desc: 'Returns a Pokemon',
          action_path: '/pokemons/{id}',
          action_request_schema: nil,
          action_response_schema_success: nil,
          action_response_schema_fail: nil,
          action_params: { id: { type: :number } },
          action_query_params: [
            explode: true,
            in: 'query',
            name: 'filter',
            required: false,
            schema: {
              example: { updated_at_gt: '2018-02-03 10:30:00' },
              properties: { updated_at_gt: { title: 'date', type: 'string' } },
              required: ['updated_at_gt'],
              type: 'object'
            },
            style: 'deepObject'
          ]
        }
      end

      it 'adds metadata to test' do
        expect(DoxActionShowExample.metadata).to match(expected_output)
      end
    end
  end
end
