module Pokemons
  extend Dox::DSL::Syntax

  show_params = { id: { type: :number } }

  document :api do
    group 'Pokemons' do
      desc 'Pokemons group desc'
    end

    resource 'Pokemons' do
      endpoint '/pokemons'
      group 'Pokemons'
    end
  end

  document :index do
    action 'Get Pokemons'
  end

  document :show do
    action 'Get Pokemon' do
      verb 'GET'
      desc 'Returns a Pokemon'
      path '/pokemons/{id}'
      params show_params
    end
  end
end

class DocApiBase
  class << self
    def metadata
      @metadata ||= {}
    end
  end
end

class DocApiExample < DocApiBase
  include Pokemons::Api
end

class DoxActionIndexExample < DocApiBase
  include Pokemons::Api
  include Pokemons::Index
end

class DoxActionShowExample < DocApiBase
  include Pokemons::Api
  include Pokemons::Show
end
