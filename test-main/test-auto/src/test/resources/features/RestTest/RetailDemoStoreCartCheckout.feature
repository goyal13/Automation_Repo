@rest
Feature: This feaure is to Test the Retail demo cart checkout feature

  @sanity
  Scenario: Add a product to the cart and checkout - as guest user
    #Perform Checkout with below details
    Given Set the base uri as "<PROPVALUE(demo.website.checkout.base.url)>"
    And Set Json payload located in file "/checkout.json"
    When Perform POST request where uri is "/orders"
    Then Validate the Response code is "201"
    And Validate Json Response Key "username" have value "guest"
    And Validate Json Response Key "items[0].product_id" have value "52"

  Scenario: Add a product to the cart and checkout - Logged in user
    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test_signup_completed)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "id" is Not blank
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"

    Given Set the base uri as "<PROPVALUE(demo.website.checkout.base.url)>"
    And Update and Set Json payload located in file "/checkout.json" by updating below keys
      | key      | value                       |
      | id       | <PROPVALUE(cart_id)>                        |
      | username | <PROPVALUE(username_test_signup_completed)> |

    When Perform POST request where uri is "/orders"
    Then Validate the Response code is "201"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"
    And Validate Json Response Key "id" is Not blank
    And Save Json Response Key-Value pair for "id" as "order_id"
    And Validate Json Response Key "items[0].product_id" have value "52"

    #Check order history deatils have the data
    Given Set the base uri as "<PROPVALUE(demo.website.checkout.base.url)>"
    When Perform GET request where uri is "/orders/username/<PROPVALUE(username_test_signup_completed)>"
    Then Validate the Response code is "200"
    And Validate Response contains "<PROPVALUE(order_id)>"

  Scenario: Add multiple product to the cart and checkout - Logged in user
    #Get Card Id
    Given Set the base uri as "<PROPVALUE(demo.website.cart.base.url)>"
    Given Set Json payload as "{"username":"<PROPVALUE(username_test_signup_completed)>"}"
    When Perform POST request where uri is "/carts"
    Then Validate the Response code is "201"
    And Save Json Response Key-Value pair for "id" as "cart_id"
    And Validate Json Response Key "id" is Not blank
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"

    Given Set the base uri as "<PROPVALUE(demo.website.checkout.base.url)>"
    And Update and Set Json payload located in file "/checkout_multiple_items.json" by updating below keys
      | key      | value                       |
      | id       | <PROPVALUE(cart_id)>                        |
      | username | <PROPVALUE(username_test_signup_completed)> |

    When Perform POST request where uri is "/orders"
    Then Validate the Response code is "201"
    And Validate Json Response Key "username" have value "<PROPVALUE(username_test_signup_completed)>"
    And Validate Json Response Key "id" is Not blank
    And Validate Json Response Key "items[0].product_id" have value "1"
    And Validate Json Response Key "items[1].product_id" have value "2"
    And Validate Json Response Key "items[2].product_id" have value "3"
    And Validate Json Response Key "items[3].product_id" have value "4"
    And Validate Json Response Key "items[4].product_id" have value "5"

  Scenario Outline: Perform checkout keeping mandatory fields as blank : Scenario <scenario>
    #Perform Checkout with below details
    Given Set the base uri as "<PROPVALUE(demo.website.checkout.base.url)>"
    And Update and Set Json payload located in file "/checkout.json" by updating payload json key "<key>" with value "<value>"
    When Perform POST request where uri is "/orders"
    Then Validate the Response code is "400"

    Examples:
      | scenario                                | key                        | value |
      | cart id is blank                        | id                         |       |
      | username is blank                       | username                   |       |
      | product id is blank                     | items[0].product_id        |       |
      | product quantity is blank               | items[0].quantity          |       |
      | product price is blank                  | items[0].price             |       |
      | Billing address first name is blank     | billing_address.first_name |       |
      | Billing address last name is blank      | billing_address.last_name  |       |
      | Billing address address1 field is blank | billing_address.address1   |       |
      | Billing address city is blank           | billing_address.city       |       |
      | Billing address state is blank          | billing_address.state      |       |
      | Billing address zipcode is blank        | billing_address.zipcode    |       |


