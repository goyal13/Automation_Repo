@rest
Feature: This feature is to test the update user functionality

  @sanity
  Scenario: Update user details for logged in user
    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test_signup_completed)>"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "user_id"

    And Update and Set Json payload located in file "/update_user_details.json" by updating below keys
      | key        | value                                                 |
      | email      | test_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>@test.com |
      | first_name | First_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>         |
      | last_name  | Last_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>          |

    And Save Json Request Key-Value pair for "email" as "email"
    And Save Json Request Key-Value pair for "first_name" as "first_name"
    And Save Json Request Key-Value pair for "last_name" as "last_name"
    When Perform PUT request where uri is "/users/id/<PROPVALUE(user_id)>"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "<PROPVALUE(user_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"
    And Validate Json Response Key "email" have value "<PROPVALUE(email)>"
    And Validate Json Response Key "first_name" have value "<PROPVALUE(first_name)>"
    And Validate Json Response Key "last_name" have value "<PROPVALUE(last_name)>"

    #Check details after logout
    Given Clear Headers and cookies
    When Perform GET request where uri is "/users/id/<PROPVALUE(user_id)>"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "<PROPVALUE(user_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"
    And Validate Json Response Key "email" have value "<PROPVALUE(email)>"
    And Validate Json Response Key "first_name" have value "<PROPVALUE(first_name)>"
    And Validate Json Response Key "last_name" have value "<PROPVALUE(last_name)>"

