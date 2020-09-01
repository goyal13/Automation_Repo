@UI
Feature: Customer creation Page checks UI

  @sanity
  Scenario: Create account with valid credentials
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    And Validate account creation with valid user credentials

  Scenario: Create account with In valid credentials
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate account with username "", password "<PROPVALUE(PASSWORD)>", email "abc@test.com" and phone no "1234567890" returns error "The following fields must be completed: Username"
    Then Validate account with username "TestUser123456_team1", password "", email "abc@test.com" and phone no "1234567890" returns error "The following fields must be completed: Password"
    Then Validate account with username "TestUser123456_team1", password "<PROPVALUE(PASSWORD)>", email "" and phone no "1234567890" returns error "The following fields must be completed: Email"
    Then Validate account with username "TestUser123456_team1", password "<PROPVALUE(PASSWORD)>", email "abc@test.com" and phone no "" returns error "The following fields must be completed: Phone Number"