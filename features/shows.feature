@no-txn
Feature: Shows
  In order to learn about the shows
  As a visitor
  I want to read information related to shows
  
  Background:
    Given a festival "MICF" in 2011
  
  Scenario: Viewing other shows by the same act or performers
    Given a show "Open Slather" by "Tripod"
    And a show "Tosswinkle the Pirate" by "Tripod"
    And a show "Scott Edgar and the Universe" by "Scott Edgar and the Universe"
    And "Scott Edgar" is part of "Scott Edgar and the Universe"
    And "Scott Edgar" is part of "Tripod"
    When I go to the show page for "Open Slather"
    Then I should see "Tosswinkle the Pirate"
    And I should see "Scott Edgar and the Universe"
  
  Scenario: Viewing List of Shows
    Given a show "Open Slather"
      And a show "Tosswinkle"
      And a show "Lady Robots"
      And the show indexes are processed
    When  I go to the shows page
    Then  I should see "Open Slather"
      And I should see "Tosswinkle"
      And I should see "Lady Robots"
  
