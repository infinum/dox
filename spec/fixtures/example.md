Format: 1A
# Pokemon API Documentation

This api is implemented according to JSON API spec.

# Group Pokemons & Digimons
Pokemons desc

## Pokemons [/pokemons]


### Create pokemon [POST /pokemons]


+ Request creates pokemon
**POST**&nbsp;&nbsp;`/pokemons`

    + Headers

            Content-Type: application/json

    + Body

            {
              "pokemon": {
                "name": "Pikachu",
                "type": "electric"
              }
            }

+ Response 201

    + Headers

            Content-Type: application/json

    + Body

            {
              "pokemon": {
                "id": 1,
                "name": "Pikachu",
                "type": "electric"
              }
            }

### Get pokemon [GET /pokemons/{id}]

+ Parameters
    + id: `14` (string, required)

+ Request returns pokemon
**GET**&nbsp;&nbsp;`/pokemons/14`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json

    + Body

            {
              "pokemon": {
                "id": 14,
                "name": "Pikachu",
                "type": "electric"
              }
            }

## Digimons [/digimons]
Digimons desc

### Get digimons [GET /digimons]
Returns all digimons

+ Request returns digimons
**GET**&nbsp;&nbsp;`/digimons`

    + Headers

            Accept: application/json

+ Response 200

    + Headers

            Content-Type: application/json

    + Body

            [
              {
                "digimon": {
                  "id": 11,
                  "name": "Tanemon",
                  "type": "Bulb"
                }
              },
              {
                "digimon": {
                  "id": 12,
                  "name": "Pyocomon",
                  "type": "Bulb"
                }
              }
            ]
