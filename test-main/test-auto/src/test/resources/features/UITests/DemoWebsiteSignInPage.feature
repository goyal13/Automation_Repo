@UI
Feature: Feature to test sign in

  @sanity
  Scenario: SignIn with a valid user
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate sign with valid user credentials

  Scenario: SignIn with a Wrong Password
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate signIn with username "<PROPVALUE(username_test_signup_completed)>" and password "Password@123" returns error "Incorrect username or password."

  Scenario: SignIn with a unconfimed user
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate signIn with username "<PROPVALUE(username_test_Not_Authorized)>" and password "<PROPVALUE(PASSWORD)>" is successful

  Scenario: SignIn with a Invalid user
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate signIn with username "" and password "<PROPVALUE(PASSWORD)>" returns error "Username cannot be empty"
    Then Validate signIn with username "TestUser1234" and password "" returns error "Password cannot be empty"