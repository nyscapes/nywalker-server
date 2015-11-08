Feature: researcher add data to instance of placename

  As a researcher
  I want to add page number, surrounding text, to an instance of a placename
  So I can have added data attached to the instance

  Scenario Outline: add data to instance
    Given that an instance exists
    When I add an "<attribute>"
    And it is a "<type>"
    Then it gets saved

    Scenarios: add data
      | attribute | type |
      | page | Integer |
      | place | Place |


