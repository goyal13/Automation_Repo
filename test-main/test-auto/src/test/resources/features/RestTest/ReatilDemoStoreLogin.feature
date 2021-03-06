@rest
Feature: This feature is to test the Login functionality for demo website

  Scenario: Login with valid username and password - Unconfirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    And Set Json payload located in file "/RegisterUser.json"
    And Save Json Request Key-Value pair for "Username" as "Username"
    And Save Json Request Key-Value pair for "UserAttributes[0].Value" as "email"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "phone_number"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "SMS"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "+********"
    And Save Json Response Key-Value pair for "UserSub" as "UserSub"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(Username)>" and password "<PROPVALUE(PASSWORD)>"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.UserNotConfirmedException: User is not confirmed."

  @sanity
  Scenario: Login with valid username and password - Confirmed User
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username_test_signup_completed)>" and password "<PROPVALUE(PASSWORD)>"
    And Validate AWS Cognito login response with key "email_verified" contains value "true"
    And Validate AWS Cognito login response with key "phone_number_verified" contains value "false"
    And Validate AWS Cognito login response with key "email" contains value "<PROPVALUE(email)>"

    #Get User Details with Logged-In Token
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Set Json payload as "{"AccessToken":"<PROPVALUE(loginToken)>""
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.GetUser"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserAttributes[0].Name" have value "sub"
    And Validate Json Response Key "UserAttributes[1].Name" have value "email_verified"
    And Validate Json Response Key "UserAttributes[1].Value" have value "true"
    And Validate Json Response Key "UserAttributes[3].Name" have value "phone_number_verified"
    And Validate Json Response Key "UserAttributes[3].Value" have value "false"
    And Validate Json Response Key "UserAttributes[4].Name" have value "email"
    And Validate Json Response Key "UserAttributes[4].Value" have value "<PROPVALUE(EMAIL_ID)>"

    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test_signup_completed)>"
    Then Validate the Response code is "200"

  Scenario: Login with valid username and wrong password - Confirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "<PROPVALUE(EMAIL_ID_HIDDEN)>"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"<PROPVALUE(CLIENTAPP_ID)>","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."

  Scenario: Login with valid username and wrong password - Max attempts - Confirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "<PROPVALUE(EMAIL_ID_HIDDEN)>"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"<PROPVALUE(CLIENTAPP_ID)>","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Password attempts exceeded"
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."
    #Login with Valid username and Password
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "<PROPVALUE(PASSWORD)>"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Password attempts exceeded"

  Scenario: Login Functionality - Field Checks
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username_test_Not_Authorized)>" and password ""
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."

    Given Authenticate and login to AWS Cognito using username "" and password "<PROPVALUE(PASSWORD)>"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.InvalidParameterException: Missing required parameter USERNAME"

    Given Authenticate and login to AWS Cognito using username "" and password ""
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.InvalidParameterException: Missing required parameter USERNAME"

    Given Authenticate and login to AWS Cognito using username "userdoesnotexists" and password "<PROPVALUE(PASSWORD)>"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.UserNotFoundException: User does not exist."