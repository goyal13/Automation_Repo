@rest
Feature: This feature is to test the Create User account flow

  Scenario: Create Account - Positive
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    And Set Json payload located in file "/RegisterUser.json"
    And Save Json Request Key-Value pair for "Username" as "Username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "phone_number"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "SMS"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "+********"
    And Save Json Response Key-Value pair for "UserSub" as "UserSub"

  Scenario: Create Account - Duplicate Users
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    And Set Json payload located in file "/RegisterUser.json"
    And Save Json Request Key-Value pair for "Username" as "username"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "phone_number"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "SMS"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "+********"
    #Create duplicate User
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "Username" with value "<PROPVALUE(username)>"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "__type" have value "UsernameExistsException"
    And Validate Json Response Key "message" have value "User already exists"
    #Create duplicate User one more time
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "Username" with value "<PROPVALUE(username)>"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "__type" have value "UsernameExistsException"
    And Validate Json Response Key "message" have value "User already exists"

  Scenario: Create account should work without Email or Phone no
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[0].Value" with value ""
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "phone_number"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "SMS"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "+********"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "UserAttributes[1].Value" with value ""
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"

  Scenario: Create account should work without Email and Phone no
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating below keys
      | key                     | value |
      | UserAttributes[0].Value |       |
      | UserAttributes[1].Value |       |
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "UserConfirmed" have value "false"
    And Validate Json Response Key "UserSub" is Not blank

  Scenario Outline: Create Account - Input data validations - Scenario: <scenario>
    Given Set the base uri as "<PROPVALUE(demo.webiste.cognito.url)>"
    Given Update and Set Json payload located in file "/RegisterUser.json" by updating payload json key "<req_attribute>" with value "<req_value>"
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.SignUp"
    When Perform POST request where uri is "/"
    Then Validate the Response code is "<status_code>"
    And Validate Json Response Key "<response_key>" contains value "<response_value>"

    Examples:
      | scenario                        | req_attribute           | req_value                                                                                                                     | status_code | response_key                      | response_value                                                                                                                                                                                                                                                          |
      | Client ID is blank              | ClientId                |                                                                                                                               | 400         | message                           | 2 validation errors detected: Value at 'clientId' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\w+]+; Value at 'clientId' failed to satisfy constraint: Member must have length greater than or equal to 1                           |
      | UserName is blank               | Username                |                                                                                                                               | 400         | message                           | 2 validation errors detected: Value at 'username' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\p{L}\\p{M}\\p{S}\\p{N}\\p{P}]+; Value at 'username' failed to satisfy constraint: Member must have length greater than or equal to 1 |
      | UserName is too long            | Username                | testautothonteam1_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>_mmnmnnmsncmncmsdncmnnnnn8y86868575646465878098078574645ncmndmsbdjbh | 200         | UserConfirmed                     | false                                                                                                                                                                                                                                                                   |
      | UserName has special characters | Username                | testautothonteam1_<GENERATE_TIMESTAMP(ddMMyyyyHHmmssSSS)>_@!#$%^&*()_+?><                                                     | 200         | UserConfirmed                     | false                                                                                                                                                                                                                                                                   |
      | Password is blank               | Password                |                                                                                                                               | 400         | message                           | 2 validation errors detected: Value at 'password' failed to satisfy constraint: Member must satisfy regular expression pattern: ^[\\S]+.*[\\S]+$; Value at 'password' failed to satisfy constraint: Member must have length greater than or equal to 6                  |
      | Password is too short - 1 Char  | Password                | p                                                                                                                             | 400         | message                           | 2 validation errors detected: Value at 'password' failed to satisfy constraint: Member must satisfy regular expression pattern: ^[\\S]+.*[\\S]+$; Value at 'password' failed to satisfy constraint: Member must have length greater than or equal to 6                  |
      | Password is too short - 5 Char  | Password                | p@word                                                                                                                        | 400         | message                           | Password did not conform with policy: Password not long enough                                                                                                                                                                                                          |
      | Password is Non compliant       | Password                | P@1.><?}}}}{{                                                                                                                 | 400         | message                           | Password did not conform with policy: Password must have lowercase characters                                                                                                                                                                                           |
      | Email id is incorrect           | UserAttributes[0].Value | teamoneautothon                                                                                                               | 400         | message                           | Invalid email address format.                                                                                                                                                                                                                                           |
      | Phone number has Alphabets      | UserAttributes[1].Value | teamoneautothon1234                                                                                                           | 400         | message                           | Invalid phone number format.                                                                                                                                                                                                                                            |
      | Phone number too short          | UserAttributes[1].Value | 961                                                                                                                           | 400         | message                           | Invalid phone number format.                                                                                                                                                                                                                                            |
      | Phone number too long           | UserAttributes[1].Value | 96192737250009619273725                                                                                                       | 400         | message                           | Invalid phone number format.                                                                                                                                                                                                                                            |

  Scenario: Create account and complete sign up
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
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"

  Scenario: Create account, Enter wrong OTP then Resend OTP and complete sign up
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
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"1111111","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "400"
    And Validate Json Response Key "message" have value "Invalid verification code provided, please try again."
    #Resend OTP
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ResendConfirmationCode"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","Username":"<PROPVALUE(username)>"}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"
    And Validate Json Response Key "CodeDeliveryDetails.AttributeName" have value "email"
    And Validate Json Response Key "CodeDeliveryDetails.DeliveryMedium" have value "EMAIL"
    And Validate Json Response Key "CodeDeliveryDetails.Destination" contains value "c***@m***.com"
    Then Get and store OTP as "signupOTP"
    Given Clear Headers and cookies
    And Set the Request header with key "content-type" and value "application/x-amz-json-1.1"
    And Set the Request header with key "x-amz-target" and value "AWSCognitoIdentityProviderService.ConfirmSignUp"
    When Set Json payload as "{"ClientId":"67ne7914v6ri9ivjj59s5cr1nc","ConfirmationCode":"<PROPVALUE(signupOTP)>","Username":"<PROPVALUE(username)>","ForceAliasCreation":true}"
    And Perform POST request where uri is "/"
    Then Validate the Response code is "200"
