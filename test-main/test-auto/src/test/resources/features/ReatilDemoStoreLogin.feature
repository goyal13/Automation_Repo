Feature: This feature is to test the Login functionality for demo website

  Scenario: Login with valid username and password - Unconfirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.signup.url)>"
    And Set Json payload located in file "/RegisterUser.json"
    And Save Json Request Key-Value pair for "Username" as "Username"
    And Save Json Request Key-Value pair for "UserAttributes[0].Value" as "email"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST requset where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "phone_number"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "SMS"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "+********"
    And Save Json Response Key-Value pair for "UserSub" as "UserSub"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(Username)>" and password "Password@1234"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.UserNotConfirmedException: User is not confirmed."

  Scenario: Login with valid username and password - Confirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.signup.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST requset where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST requset where uri is "/"
    Then Validate the Response code is "200"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@1234"
    And Validate AWS Cognito login response with key "email_verified" contains value "true"
    And Validate AWS Cognito login response with key "sub" contains value "<PROPVALUE(UserSub)>"
    And Validate AWS Cognito login response with key "phone_number_verified" contains value "false"
    And Validate AWS Cognito login response with key "email" contains value "<PROPVALUE(email)>"

  Scenario: Login with invalid username and password - Confirmed User
    Given Set the base uri as "<PROPVALUE(demo.webiste.signup.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST requset where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST requset where uri is "/"
    Then Validate the Response code is "200"

    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password "Password@123"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.NotAuthorizedException: Incorrect username or password."


  Scenario: Login Functionality - Field Checks
    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username)>" and password ""
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.InvalidParameterException: Missing required parameter USERNAME"

    Given Authenticate and login to AWS Cognito using username "" and password "Password@1234"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.InvalidParameterException: Missing required parameter USERNAME"

    Given Authenticate and login to AWS Cognito using username "" and password ""
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.InvalidParameterException: Missing required parameter USERNAME"

    Given Authenticate and login to AWS Cognito using username "userdoesnotexists" and password "Password@1234"
    And Validate AWS Cognito login response with key "message" contains value "com.amazonaws.services.cognitoidp.model.UserNotFoundException: User does not exist."