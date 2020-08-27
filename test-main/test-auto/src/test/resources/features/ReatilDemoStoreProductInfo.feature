@rest
Feature: This feature is to test the Products listed on the Demo shopping website

  Scenario: Get all product list from the website
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/categories/all"
    Then Validate the Response code is "200"
    And Validate Json Response is Not blank
    And Validate Json response size for key "" is "8"
    And Validate Json Response Key "[0].name" have value "footwear"
    And Validate Json Response Key "[0].id" is Not blank
    And Validate Json Response Key "[0].image" is Not blank
    And Validate Json Response Key "[0].url" is Not blank

    And Validate Json Response Key "[1].name" have value "housewares"
    And Validate Json Response Key "[1].id" is Not blank
    And Validate Json Response Key "[1].image" is Not blank
    And Validate Json Response Key "[1].url" is Not blank

    And Validate Json Response Key "[2].name" have value "apparel"
    And Validate Json Response Key "[2].id" is Not blank
    And Validate Json Response Key "[2].image" is Not blank
    And Validate Json Response Key "[2].url" is Not blank

    And Validate Json Response Key "[3].name" have value "jewelry"
    And Validate Json Response Key "[3].id" is Not blank
    And Validate Json Response Key "[3].image" is Not blank
    And Validate Json Response Key "[3].url" is Not blank

    And Validate Json Response Key "[4].name" have value "beauty"
    And Validate Json Response Key "[4].id" is Not blank
    And Validate Json Response Key "[4].image" is Not blank
    And Validate Json Response Key "[4].url" is Not blank

    And Validate Json Response Key "[5].name" have value "electronics"
    And Validate Json Response Key "[5].id" is Not blank
    And Validate Json Response Key "[5].image" is Not blank
    And Validate Json Response Key "[5].url" is Not blank

    And Validate Json Response Key "[6].name" have value "accessories"
    And Validate Json Response Key "[6].id" is Not blank
    And Validate Json Response Key "[6].image" is Not blank
    And Validate Json Response Key "[6].url" is Not blank

    And Validate Json Response Key "[7].name" have value "outdoors"
    And Validate Json Response Key "[7].id" is Not blank
    And Validate Json Response Key "[7].image" is Not blank
    And Validate Json Response Key "[7].url" is Not blank

  Scenario Outline: Validate product category <product> is correct and returning 200
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/category/<product>"
    Then Validate the Response code is "200"
    And Validate Json Response is Not blank
    And Validate Json Response Key "[0].category" have value "<product>"
    And Validate Json Response Key "[0].description" is Not blank
    And Validate Json Response Key "[0].id" is Not blank
    And Validate Json Response Key "[0].image" is Not blank
    And Validate Json Response Key "[0].name" is Not blank
    And Validate Json Response Key "[0].price" is Not blank
    And Validate Json Response Key "[0].sk" is blank
    And Validate Json Response Key "[0].style" is Not blank
    And Validate Json Response Key "[0].url" is Not blank

    Examples:
      | product     |
      | footwear    |
      | housewares  |
      | apparel     |
      | jewelry     |
      | beauty      |
      | electronics |
      | accessories |
      | outdoors    |

  Scenario Outline: Validate All product under category <product> has data
    Given Validate All items under category "<product>" has data for fields "category,description,id,image,name,price,style,url"
    Examples:
      | product     |
      | footwear    |
      | housewares  |
      | apparel     |
      | jewelry     |
      | beauty      |
      | electronics |
      | accessories |
      | outdoors    |


  Scenario Outline: Validate All Related products shown for a selected product category <product> are shown as expected
    Given Set the base uri as "<PROPVALUE(demo.website.rest.base.url)>"
    When Perform GET request where uri is "/products/category/<product>"
    Then Validate the Response code is "200"
    And Validate Json Response is Not blank
    And Validate Json Response Key "[0].category" have value "<product>"
    And Save Json Response Key-Value pair for "[0].id" as "product_id"
    Given Set the base uri as "<PROPVALUE(demo.website.relateditem.base.url)>"
    When Perform GET request where uri is "/related?userID=&currentItemID=<PROPVALUE(product_id)>&numResults=6&feature=product_detail_related&fullyQualifyImageUrls=1"
    Then Validate the Response code is "200"
    And Validate Json response size for key "" is "6"
    And Validate Json Response Key "[0].product.category" have value "<product>"
    And Validate Json Response Key "[1].product.category" have value "<product>"
    And Validate Json Response Key "[2].product.category" have value "<product>"
    And Validate Json Response Key "[3].product.category" have value "<product>"
    And Validate Json Response Key "[4].product.category" have value "<product>"
    And Validate Json Response Key "[5].product.category" have value "<product>"

    Examples:
      | product     |
      | footwear    |
      | housewares  |
      | apparel     |
      | jewelry     |
      | beauty      |
      | electronics |
      | accessories |
      | outdoors    |




















