@UI
Feature: Test Landing page UI

  Scenario: All links should return 200
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Given Validate all links on landing page are retruning 200

  @sanity
  Scenario: Validate Header on Landing page
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate no of carousels in landing page is "4"
    And Validate Header with text "Free Shipping on All Orders over $10000" exists in landing page

  Scenario: Validate carousels on Landing page
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    Then Validate no of carousels in landing page is "4"

  Scenario: Validate Products on Landing page
    Given I launch "<PROPVALUE(DEMO_WEBSITE)>"
    And Validate product category "Footwear" exists in landing page
    And Validate product category "Housewares" exists in landing page
    And Validate product category "Apparel" exists in landing page
    And Validate product category "Beauty" exists in landing page
    And Validate product category "Electronics" exists in landing page
    And Validate product category "Accessories" exists in landing page
    And Validate product category "Outdoors" exists in landing page