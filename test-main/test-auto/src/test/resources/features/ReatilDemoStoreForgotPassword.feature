@rest
Feature: This feature is to test the Reset/Forgot Password flow


  Scenario: Resend/Forgot Password - User verified
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    #Forget Password
    And Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>"}"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ForgotPassword"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmForgotPassword"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>","ConfirmationCode":"<PROPVALUE(signupOTP)>","Password":"Password@1234"}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"

  Scenario: Resend/Forgot Password - User verified but wrong OTP
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    #Forget Password
    And Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>"}"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ForgotPassword"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmForgotPassword"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>","ConfirmationCode":"12345","Password":"Password@1234"}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "message" have value "Invalid verification code provided, please try again."


  Scenario: Resend/Forgot Password - User not verified
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>"}"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ForgotPassword"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "message" have value "Cannot reset password for the user as there is no registered/verified email or phone_number"

  Scenario: Resend code - User Field is Blank
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    And Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":""}"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ForgotPassword"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "message" have value "2 validation errors detected: Value at 'username' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\p{L}\\p{M}\\p{S}\\p{N}\\p{P}]+; Value at 'username' failed to satisfy constraint: Member must have length greater than or equal to 1"

  Scenario Outline: Forgot Password - Field Validations - Scenario: <scenario>
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmForgotPassword"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"testuser@gmail.com","ConfirmationCode":"12345","Password":"Password@1234"}"
    And Update and Set Json payload by updating payload json key "<req_attribute>" with value "<req_value>"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "<status_code>"
    And Validate Json Response Key "<response_key>" contains value "<response_value>"

    Examples:
      | scenario                   | req_attribute    | req_value | status_code | response_key | response_value                                                                                                                                                                                                                                                          |
      | Client ID is blank         | ClientId         |           | 400         | message      | 2 validation errors detected: Value at 'clientId' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\w+]+; Value at 'clientId' failed to satisfy constraint: Member must have length greater than or equal to 1                           |
      | UserName is blank          | Username         |           | 400         | message      | 2 validation errors detected: Value at 'username' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\p{L}\\p{M}\\p{S}\\p{N}\\p{P}]+; Value at 'username' failed to satisfy constraint: Member must have length greater than or equal to 1 |
      | Confirmation code is blank | ConfirmationCode |           | 400         | message      | 2 validation errors detected: Value '' at 'confirmationCode' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\S]+; Value '' at 'confirmationCode' failed to satisfy constraint: Member must have length greater than or equal to 1      |
      | Password is blank          | Password         |           | 400         | message      | 2 validation errors detected: Value at 'password' failed to satisfy constraint: Member must satisfy regular expression pattern: ^[\\S]+.*[\\S]+$; Value at 'password' failed to satisfy constraint: Member must have length greater than or equal to 6                  |


