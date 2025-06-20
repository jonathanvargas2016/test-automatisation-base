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