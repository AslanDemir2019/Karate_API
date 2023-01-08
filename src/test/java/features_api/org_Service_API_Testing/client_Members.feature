@client_Members
#  @RegressionClientCalls
#  @SmokeTest
Feature: Client Members

  Background:
    * url appUrl
    * def clientCallHeaders = {Accept:'*/*' , User-Agent : 'Thunder Client (https://www.thunderclient.com)'}

  Scenario: Check GET List Response Schema
    * def getClientContactSchema = read('classpath:resources/client_members_schema.json')
    Given path 'organization/client_members'
    And headers clientCallHeaders
    When method GET
    Then status 200
    #And print response
    And match response == getClientContactSchema

  Scenario: GET List Filter Test
    * def client_id = '6c2d548a-71b8-11ed-a816-2b1051107c43'
    * def member_id = '00000000-0000-0000-0000-000000000001'
    * def member_status = 'Active'
    Given path 'organization/client_members'
    And headers clientCallHeaders
    And param filters.client_id = client_id
    And param filters.member_id = member_id
    And param filters.member_id = member_id
    When method GET
    And print response
    Then status 200
    And match response == "#notnull"
    And match each response.data[*].client_id == client_id
    And match each response.data[*].member_id == member_id
    And match each response.data[*].member_status == member_status


  Scenario: GET Existing Response Schema
    * def getClientContactSchema = read('classpath:resources/client_members_data_schema.json')
    * string id = "7768eb20-71b8-11ed-a816-a716ed03b593"
    Given path 'organization/client_members/' + id
    And headers clientCallHeaders
    When method GET
    Then status 200
    And match response == getClientContactSchema
    And print response
    And match response.id == id


  Scenario: GET Non Existing Response Schema
    * string id = "0000000-0000-0000-0000-00000000000"
    Given path 'organization/client_members/' + id
    And headers clientCallHeaders
    When method GET
    Then status 404
    And print response


  Scenario: POST Create a client member with bad client id
    * def requestBody = read('classpath:resources/create_update_client_members_request.json')
    * def getClientContactSchema = read('classpath:resources/client_members_data_schema.json')
    * requestBody.member_id = '00000000-0000-0000-0000-000000000000'
    * requestBody.client_id = '00000000-0000-0000-0000-000000000000'
    * requestBody.external_member_id = '123456789'
    * requestBody.member_status = 'Active'
    And print requestBody
    Given path 'organization/client_members'
    And headers clientCallHeaders
    And request requestBody
    When method POST
    Then status 500
    Then response.member_id == requestBody.member_id
    And response.client_id == requestBody.client_id
    And response.external_member_id == requestBody.external_member_id
    And response.member_status == requestBody.member_status
    And  match response == '"' + "Internal Server Error" + '"'


  Scenario: POST Create a client member
    * def requestBody = read('classpath:resources/create_update_client_members_request.json')
    * def getClientContactSchema = read('classpath:resources/client_members_data_schema.json')
    * requestBody.member_id = '00000000-0000-0000-0000-000000000000'
    * requestBody.client_id = '61f16fd8-71b8-11ed-a816-0faf3807635e'
    * requestBody.external_member_id = '123'
    * requestBody.member_status = 'Active'
    And print requestBody
    Given path 'organization/client_members'
    And headers clientCallHeaders
    And request requestBody
    When method POST
    Then status 200
    Then response.member_id == requestBody.member_id
    And response.client_id == requestBody.client_id
    And response.external_member_id == requestBody.external_member_id
    And response.member_status == requestBody.member_status
    And  match response == getClientContactSchema


  Scenario: PUT Update existing client member
    * def requestBody = read('classpath:resources/create_update_client_members_request.json')
    * def getClientContactSchema = read('classpath:resources/client_members_data_schema.json')
    * requestBody.member_id = '00000000-0000-0000-0000-000000000000'
    * requestBody.client_id = '61f16fd8-71b8-11ed-a816-0faf3807635e'
    * requestBody.external_member_id = '123456789'
    * requestBody.member_status = 'Active'
    And print requestBody
    Given path 'organization/client_members/' + 'a1b2549e-8ae9-11ed-8401-cb05347cae87'
    And headers clientCallHeaders
    And request requestBody
    When method PUT
    Then status 200
#    Then response.member_id == requestBody.member_id
#    And response.client_id == requestBody.client_id
#    And response.external_member_id == requestBody.external_member_id
#    And response.member_status == requestBody.member_status
    And  match response == getClientContactSchema


  Scenario: PUT Update non-existing client member
    * def requestBody = read('classpath:resources/create_update_client_members_request.json')
    * def getClientContactSchema = read('classpath:resources/client_members_data_schema.json')
    * requestBody.member_id = '00000000-0000-0000-0000-000000000001'
    * requestBody.client_id = '6c2d548a-71b8-11ed-a816-2b1051107c43'
    * requestBody.external_member_id = '12345978901'
    * requestBody.member_status = 'Active'
    And print requestBody
    Given path 'organization/client_members/' + '00000000-0000-0000-0000-000000000000'
    And headers clientCallHeaders
    And request requestBody
    When method PUT
    Then status 404
#    Then response.member_id == requestBody.member_id
#    And response.client_id == requestBody.client_id
#    And response.external_member_id == requestBody.external_member_id
#    And response.member_status == requestBody.member_status
    And  match response == '"' + "Member [00000000-0000-0000-0000-000000000000] - Not Found!" + '"'


  Scenario: DELETE non-existing client member
    Given path 'organization/client_members/' + '00000000-0000-0000-0000-000000000000'
    And headers clientCallHeaders
    When method DELETE
    Then status 404
    And  match response == '"' + "Member [00000000-0000-0000-0000-000000000000] - Not Found!" + '"'




