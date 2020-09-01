@UI
Feature: Add Product and checkout

  @sanity
  Scenario: Add single Product to cart and checkout
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    And Validate sign with valid user credentials
    When Add product at "Jewelry>Gold Bracelt with Multi-Color Tassels" to the cart
    Then Validate checkout is successful

  Scenario: Add Multiple Product to cart and checkout
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    And Validate sign with valid user credentials
    When Add product at "Jewelry>Gold Bracelt with Multi-Color Tassels" to the cart
    When Add product at "Electronics>Blue Mushroom Wireless Speaker" to the cart
    Then Validate checkout is successful
