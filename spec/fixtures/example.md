<!-- include(/Users/someuser/api_header_demo.md) -->

# Group Pokemons & Digimons

Pokemons desc

## Pokemons [/pokemons]


### Create pokemon [POST /pokemons]




+ Request  (json)

        {
          "pokemon": {
            "name": "Pikachu",
            "type": "electric"
          }
        }
+ Response 201 (json)

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

+ Request  (json)
+ Response 200 (json)

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


+ Request  (json)
+ Response 200 (json)

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
