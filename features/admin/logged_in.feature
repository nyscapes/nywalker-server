Feature: admin login

  Scenario: The admin fixture takes
    Given I am an admin
    When I am on the homepage
    Then my username is "adminuser"
    And my username is in the navbar

  # As an admin
  # I want to log in
  # So I can access all of the site's features

# Feature: admin add user

  # As an admin
  # I want to add users
  # So they can help populate the site

# Feature: admin add novel

  # As an admin
  # I want to add a novel to the database
  # So that the database can grow


