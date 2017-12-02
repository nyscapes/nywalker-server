Feature: Adding instances

  Background: 
    Given I am an admin
    And there is a book "Moscow Blues"
    And I am on the "Moscow Blues" book page

  @wip
  Scenario: I add an instance
    When my username is "adminuser"
    When I click on the "Add instance" button
    And I fill in instance information
    And I click on the "Save" button
    Then the instance is saved

  @javascript
  Scenario: An autofill appears suggesting a place name
    Given "Moscow" is a saved place
    When I click on the "Add instance" button
    And I type "Moscow" in the "place" field
    Then the form fills in "Moscow" as the nickname
    And fills in the full "Moscow" pattern

  Scenario: I see the last instance
    Given instances exist for "Moscow Blues"
    And I created one of the instances for "Moscow Blues"
    When I click on the "Add instance" button
    Then I see the last instance

  Scenario: I see the same page and the sequence rises by one
    Given instances exist for "Moscow Blues"
    When I click on the "Add instance" button
    Then the new instance is on the same page as the previous instance
    And the sequence is increased by one

