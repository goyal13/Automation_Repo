@rest
Feature: This feature is to test the search functionality in the demo website

  Scenario: Search product with a valid product name
    Given Set the base uri as "<PROPVALUE(demo.website.search.base.url)>"
    When Perform GET request where uri is "/search/products?searchTerm=footwear"
    Then Validate the Response code is "200"
    And Validate Response contains "footwear"
    And Validate Response does not contains "NotFoundError"

  Scenario: Search product with a valid partial product name
    Given Set the base uri as "<PROPVALUE(demo.website.search.base.url)>"
    When Perform GET request where uri is "/search/products?searchTerm=foot"
    Then Validate the Response code is "200"
    And Validate Response does not contains "NotFoundError"

  Scenario: Search product with a valid product name having spaces
    Given Set the base uri as "<PROPVALUE(demo.website.search.base.url)>"
    When Perform GET request where uri is "/search/products?searchTerm=super%20knit%20sneakers"
    Then Validate the Response code is "200"
    And Validate Response does not contains "NotFoundError"


  Scenario: Search product with a invalid product name
    Given Set the base uri as "<PROPVALUE(demo.website.search.base.url)>"
    When Perform GET request where uri is "/search/products?searchTerm=abcd123"
    Then Validate the Response code is "200"
    And Validate Response contains "NotFoundError"