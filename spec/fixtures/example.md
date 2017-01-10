Format: 1A
# Pokemon API Documentation

This api is implemented according to JSON API spec.

# Group Pokemons & Digimons

Pokemons desc

## Pokemons [/pokemons]


### Create pokemon [POST /pokemons]




+ Request creates pokemon
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
