@rpinoced
Feature: Validación de endpoints de la API Marvel Personajes

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-2c14c952e422.herokuapp.com/rpinoced/api/characters'
    * header content-type = 'application/json'

  @KEY-1953-CA01
  Scenario: Crear personaje exitosamente
    * def character = read('classpath:templates/KEY-1953-CA01.json')
    Given url baseUrl
    And request character
    When method POST
    Then status 201
    And print response
    * def createdId = response.id

  @KEY-1953-CA02
  Scenario: Crear personaje con nombre duplicado
    * def character = read('classpath:templates/KEY-1953-CA01.json')
    Given url baseUrl
    And request character
    When method POST
    Then status 400
    And print response

  @KEY-1953-CA03
  Scenario: Crear personaje con campos requeridos faltantes
    * def character = read('classpath:templates/KEY-1953-CA03.json')
    Given url baseUrl
    And request character
    When method POST
    Then status 400
    And print response

  @KEY-1953-CA04
  Scenario: Actualizar personaje exitosamente
    # Obtener un personaje existente
    Given url baseUrl
    When method GET
    Then status 200
    * def characterId = response[0].id
    And print 'ID para actualizar:', characterId

    # Ejecutar la actualización
    * def character = read('classpath:templates/KEY-1953-CA04.json')
    Given url baseUrl + '/' + characterId
    And request character
    When method PUT
    Then status 200
    And print response

  @KEY-1953-CA05
  Scenario: Actualizar personaje que no existe
    * def character = read('classpath:templates/KEY-1953-CA04.json')
    Given url baseUrl + '/9999'
    And request character
    When method PUT
    Then status 404
    And print response

  @KEY-1953-CA06
  Scenario: Obtener todos los personajes
    Given url baseUrl
    When method GET
    Then status 200
    And print response

  @KEY-1953-CA07
  Scenario: Obtener personaje por ID existente
    # Obtener un personaje existente
    Given url baseUrl
    When method GET
    Then status 200
    * def characterId = response[0].id
    And print 'ID para actualizar:', characterId

    # Ejecutar la consulta
    Given url baseUrl + '/' + characterId
    When method GET
    Then status 200
    And print response

  @KEY-1953-CA08
  Scenario: Obtener personaje por ID que no existe
    Given url baseUrl + '/9999'
    When method GET
    Then status 404
    And print response

  @KEY-1953-CA09
  Scenario: Eliminar personaje exitosamente
    # Obtener un personaje existente
    Given url baseUrl
    When method GET
    Then status 200
    * def characterId = response[0].id
    And print 'ID para actualizar:', characterId

    # Ejecutar Eliminado
    Given url baseUrl + '/' + characterId
    When method DELETE
    Then status 204
    And print 'Eliminado personaje con ID:', characterId

  @KEY-1953-CA10
  Scenario: Eliminar personaje que no existe
    Given url baseUrl + '/9999'
    When method DELETE
    Then status 404
    And print response