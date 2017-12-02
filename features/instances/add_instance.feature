Feature: Adding instances

  Background: 
    Given I am an admin
    And there is a book "Moscow Blues"
    And I am on the "Moscow Blues" book page

  Scenario: I add an instance
    Given "Acushnet" is a saved place
    When I click on the "Add instance" button
    And I fill in instance information for "Acushnet"
    And I click on the "Add Instance" button
    Then the instance is saved

  @javascript
  Scenario: An autofill appears suggesting a place name
    Given "Acushnet" is a saved place
    When I click on the "Add instance" button
    And I type "Acushnet" in the "place" field
    Then the form fills in "Acushnet" as the nickname
    And fills in the full "Acushnet" pattern

  @wip
  Scenario: I see the last instance
    Given 10 instances exist for "Moscow Blues"
    And I created one of the instances for "Moscow Blues"
    When I click on the "Add instance" button
    Then I see the last instance

  Scenario: I see the same page and the sequence rises by one
    Given instances exist for "Moscow Blues"
    When I click on the "Add instance" button
    Then the new instance is on the same page as the previous instance
    And the sequence is increased by one

