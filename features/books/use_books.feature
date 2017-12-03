Feature: Using Books
  Scenario: Seeing the list of books
    Given I am on the "Books" page
    Then I should see a list of books

  Scenario: Add instance button for admin
    Given I am an admin
    And I am on the "Books" page
    Then I should see an "Add instance" link

  Scenario: Add instance button for user
    Given I am allowed to edit the book "Moscow Blues"
    And I am on the "Books" page
    # Then I should see an "Add instance" link
