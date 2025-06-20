@jvargsn @MarvelApi
Feature: Marvel Api test

  Background:
    * url "http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/"

  @GetAllCharacters
  Scenario: Get all characters
    Given path "characters"
    When method GET
    Then status 200
    * print response
    And assert response.length > 0

  @GetCharacterById
  Scenario Outline: Get character by ID <id>
    Given path 'characters', <id>
    When method GET
    Then status <statusCode>
    * print response
    Examples:
      | id  | statusCode |
      | 129 | 200        |
      | 1   | 404        |

  @CreateCharacter
  Scenario: Create a new character (successful)
    * def character =
    """
    {
      "name": "Iron Man New",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    Given path 'characters'
    And request character
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * print response
    * match response contains { id: '#notnull' }
    * match response.name == 'Iron Man New'
    * match response.alterego == 'Tony Stark'
    * match response.description == 'Genius billionaire'
    * match response.powers == ['Armor', 'Flight']

  @CreateDuplicatedCharacter
  Scenario: Create a character with duplicated name
    * def duplicatedCharacter =
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """

    Given path 'characters'
    And request duplicatedCharacter
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    * print response
    * match response contains { error: 'Character name already exists' }


  @CreateInvalidCharacter
  Scenario: Create a character with missing required fields
    * def invalidCharacter =
    """
    {
      "name": "",
    }
    """
    Given path 'characters'
    And request invalidCharacter
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    * print response
    * match response contains { name: 'Name is required' }
    * match response contains { alterego: 'Alterego is required' }
    * match response contains { description: 'Description is required' }
    * match response contains { powers: 'Powers are required' }

  @UpdateCharacter
  Scenario: Update a character (successful)
    * def characterId = 345
    * def updatedCharacter =
    """
    {
      "name": "Iron Man New",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """

    Given path 'characters', characterId
    And request updatedCharacter
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    * print response
    * match response.id == characterId
    * match response.description == 'Updated description'


  @UpdateNotExistentCharacter
  Scenario: Update when not existent a character
    * def character =
    """
    {
      "name": "Iron Man New",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """

    Given path 'characters', '999'
    And request character
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    * print response
    * match response contains { error: 'Character not found' }

  @DeleteCharacter
  Scenario: Delete a character (successful)
    Given path 'characters', 345
    When method DELETE
    Then status 204
    * print 'Character successfully deleted'


  @DeleteNotExistentCharacter
  Scenario: Delete a not existent character
    Given path 'characters', '345'
    When method DELETE
    Then status 404
    * print response
    And match response contains { error: 'Character not found' }


