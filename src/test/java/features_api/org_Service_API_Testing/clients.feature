@clients
#  @RegressionClientCalls
#  @SmokeTest
Feature: Clients

  Background:
    * url appUrl
    * def clientCallHeaders = {Accept:'*/*' , User-Agent : 'Thunder Client (https://www.thunderclient.com)'}

  Scenario: Check GET List Response Schema
    * def getClientContactSchema = read('classpath:resources/clients/clients_schema.json')
    Given path 'organization/clients'
    And headers clientCallHeaders
    When method GET
    Then status 200
    #And print response
    And match response == getClientContactSchema


  Scenario: GET List Filter Test
    * def id = '6c2d548a-71b8-11ed-a816-2b1051107c43'
    * def page = 1
    * def per_page = 20
    Given path 'organization/clients'
    And param filters.id = id
    And param filters.page = page
    And param filters.per_page = per_page
    And headers clientCallHeaders
    When method GET
    Then status 200
    #And print response
    And match response == "#notnull"
    And match each response.data[*].id == id
    And match each response.data[*].page == page
    And match each response.data[*].per_page == per_page


  Scenario: GET Existing Response Schema
    * string id = "63e72f30-71b8-11ed-a816-f32ed8b150d9"
    Given path 'organization/clients/' + id
    And headers clientCallHeaders
    When method GET
    Then status 200
    And match response == karate.read('classpath:resources/clients/clients_data_schema.json')
#    And print response
    And match response.id == id


  Scenario: GET Non-Existing Response Schema
    * string id = "00000000-0000-0000-0000-000000000000"
    Given path 'organization/clients/' + id
    And headers clientCallHeaders
    When method GET
    Then status 404
    And match response == '"' + "Client [00000000-0000-0000-0000-000000000000] - Not Found!" + '"'


  Scenario: POST Create a clients
    * def requestBody = read('classpath:resources/clients/clients_request.json')
    * def getClientContactSchema = read('classpath:resources/clients/clients_data_schema.json')
    And print requestBody
    Given path 'organization/clients'
    And headers clientCallHeaders
    And request requestBody
    When method POST
    Then status 200
    Then match response.name == requestBody.name
    And match response.client_status == requestBody.client_status
    And match response.client_type == requestBody.client_type


  Scenario: PUT Update non-existing clients
    * def requestBody = read('classpath:resources/clients/clients_request.json')
    * set requestBody.name = "clint1"
    Given path 'organization/clients/' + '00000000-0000-0000-0000-000000000000'
    And headers clientCallHeaders
    And request requestBody
    When method PUT
    Then status 404
    And  match response == '"' + "Client [00000000-0000-0000-0000-000000000000] - Not Found!" + '"'

  Scenario: PUT Update existing clients
    * def requestBody = read('classpath:resources/clients/clients_request.json')
    * def getClientContactSchema = read('classpath:resources/clients/clients_data_schema.json')
    * set requestBody.name = "clientedited"
    * set requestBody.client_status = "Active"
    * set requestBody.client_type = "Internal"
    Given path 'organization/clients/' + '6c2d548a-71b8-11ed-a816-2b1051107c43'
    And headers clientCallHeaders
    And request requestBody
    When method PUT
    Then status 200
    And  match response == getClientContactSchema
    Then match response.name == requestBody.name
    And match response.client_status == requestBody.client_status
    And match response.client_type == requestBody.client_type

  Scenario: DELETE non-existing clients
    Given path 'organization/clients/' + '00000000-0000-0000-0000-000000000000'
    And headers clientCallHeaders
    When method DELETE
    Then status 404
    And  match response == '"' + "Client [00000000-0000-0000-0000-000000000000] - Not Found!" + '"'

