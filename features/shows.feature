Feature: Shows
  In order to learn about the shows
  As a visitor
  I want to read information related to shows
  
  Scenario: Viewing other shows by the same act or performers
    Given a show "Open Slather" by "Tripod"
    And a show "Tosswinkle the Pirate" by "Tripod"
    And a show "Scott Edgar and the Universe" by "Scott Edgar and the Universe"
    And "Scott Edgar" is part of "Scott Edgar and the Universe"
    And "Scott Edgar" is part of "Tripod"
    When I go to the show page for "Open Slather"
    Then I should see "Tosswinkle the Pirate"
    And I should see "Scott Edgar and the Universe"
  
