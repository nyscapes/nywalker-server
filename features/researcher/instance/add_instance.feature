Feature: researcher add instance of placename

  As a researcher
  I want to add an instance of a placename in a database
  So I can enrich the database

  Scenario:
    Given a researcher exists
    When I create an instance
    Then it should exist
