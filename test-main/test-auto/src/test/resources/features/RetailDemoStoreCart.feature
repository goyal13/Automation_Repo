@rest
Feature: This functionality is to validate the Cart functionality

  Background: Clear the cart before each test
    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items" have value "[]"
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items" have value "[]"

  Scenario: Add a product to the cart - as guest user
    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id"
    And Save Json Response Key-Value pair for "price" as "price"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

  Scenario: Add same product to the cart multiple times - as guest user
    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id"
    And Save Json Response Key-Value pair for "price" as "price"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

  Scenario: Add multiple product to the cart - as guest user
    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id1"
    And Save Json Response Key-Value pair for "price" as "price1"

    When Perform GET request where uri is "/products/id/5"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id2"
    And Save Json Response Key-Value pair for "price" as "price2"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id1)>","quantity":1,"price":<PROPVALUE(price1)>},{"product_id":"<PROPVALUE(id2)>","quantity":2,"price":<PROPVALUE(price2)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id1)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price1)>"
    And Validate Json Response Key "items[1].product_id" have value "<PROPVALUE(id2)>"
    And Validate Json Response Key "items[1].quantity" have value "2"
    And Validate Json Response Key "items[1].price" have value "<PROPVALUE(price2)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id1)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price1)>"
    And Validate Json Response Key "items[1].product_id" have value "<PROPVALUE(id2)>"
    And Validate Json Response Key "items[1].quantity" have value "2"
    And Validate Json Response Key "items[1].price" have value "<PROPVALUE(price2)>"

  Scenario: Update multiple product in the cart - as guest user
    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id1"
    And Save Json Response Key-Value pair for "price" as "price1"

    When Perform GET request where uri is "/products/id/5"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id2"
    And Save Json Response Key-Value pair for "price" as "price2"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id1)>","quantity":20,"price":<PROPVALUE(price1)>},{"product_id":"<PROPVALUE(id2)>","quantity":1,"price":<PROPVALUE(price2)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id1)>"
    And Validate Json Response Key "items[0].quantity" have value "20"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price1)>"
    And Validate Json Response Key "items[1].product_id" have value "<PROPVALUE(id2)>"
    And Validate Json Response Key "items[1].quantity" have value "1"
    And Validate Json Response Key "items[1].price" have value "<PROPVALUE(price2)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id1)>"
    And Validate Json Response Key "items[0].quantity" have value "20"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price1)>"
    And Validate Json Response Key "items[1].product_id" have value "<PROPVALUE(id2)>"
    And Validate Json Response Key "items[1].quantity" have value "1"
    And Validate Json Response Key "items[1].price" have value "<PROPVALUE(price2)>"

  Scenario: Add a product to the cart - as Logged In user
#    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username_test2)>" and password "Password@1234"
#    And Validate AWS Cognito login response with key "email_verified" contains value "true"
    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test2)>"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "user_id"

    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test2)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"

    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id"
    And Save Json Response Key-Value pair for "price" as "price"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"<PROPVALUE(cart_id)>","username":"<PROPVALUE(username_test2)>","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

  Scenario: Add a product to the cart, log off and re-login - Items should be in the cart
#    Given Authenticate and login to AWS Cognito using username "<PROPVALUE(username_test2)>" and password "Password@1234"
#    And Validate AWS Cognito login response with key "email_verified" contains value "true"
    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test2)>"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "user_id"

    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test2)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"

    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id"
    And Save Json Response Key-Value pair for "price" as "price"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"<PROPVALUE(cart_id)>","username":"<PROPVALUE(username_test2)>","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Logoff
    Given Clear Headers and cookies
    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test2)>"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "user_id"

    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test2)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"

    When Perform GET request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Json Response Key "items" is Not blank
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

  Scenario: Add a product to the cart as a guest user then log in as a registered- Items added by guest user should not be in the cart
    #Check details of the product to be added
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/id/49"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "id"
    And Save Json Response Key-Value pair for "price" as "price"

    #Add the product
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    And Set Json payload as "{"id":"76","username":"guest","items":[{"product_id":"<PROPVALUE(id)>","quantity":1,"price":<PROPVALUE(price)>}]}"
    When Perform PUT request where uri is "/carts/id/76"
    Then Validate the Response code is "201"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/76"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "76"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "<PROPVALUE(id)>"
    And Validate Json Response Key "items[0].quantity" have value "1"
    And Validate Json Response Key "items[0].price" have value "<PROPVALUE(price)>"

    #Login as registered user
    Given Set the base uri as "<PROPVALUE(demo.website.user.base.url)>"
    When Perform GET request where uri is "/users/username/<PROPVALUE(username_test2)>"
    Then Validate the Response code is "200"
    And Save Json Response Key-Value pair for "id" as "user_id"

    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test2)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"

    #Check cart
    When Perform GET request where uri is "/carts/id/<PROPVALUE(cart_id)>"
    Then Validate the Response code is "200"
    And Validate Json Response Key "id" have value "<PROPVALUE(cart_id)>"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test2)>"
    And Validate Response contains "null"


