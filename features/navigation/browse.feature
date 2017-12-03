Feature: Browsing NYWalker
  Scenario: Seeing the index
    Given I am on the homepage
    Then I should see the Title
    And I should see the navbar
    And I should see a map

  Scenario Outline: Using the navbar
    Given I am on the homepage
    When I click "<button>" in the navbar
    Then I should be on the "<button>" page

    Examples:
      | button |
      | Books |
      | Places |
      | Rules |
      | Help |
      | About |
      # | Citing | # Save until I'm caching the citing.
