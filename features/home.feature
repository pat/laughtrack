Feature: The Home Page
  In order to find shows to see
  As a visitor
  I want to see popular and highly rated shows on the home page
  
  Scenario: Listing of Popular Shows
    Given "Inflatable" by "Adam Hills" is 80% sold out
    And "The Hotel" by "Mark Watson" is 60% sold out
    And "Randy's Postcards from Purgatory" by "Heath McIvor" is 70% sold out
    And "The Last Stand to Reason" by "Pajama Men" is 80% sold out
    And "Rabbit Faced Story Soup" by "Laura Solon" is 30% sold out
    And "1999" by "Sammy J" is 75% sold out
    When I go to the home page
    Then I should see "Inflatable" within ".popular"
    And I should see "The Hotel" within ".popular"
    And I should see "Randy's Postcards from Purgatory" within ".popular"
    And I should see "The Last Stand to Reason" within ".popular"
    And I should see "1999" within ".popular"
    And I should not see "Rabbit Faced Story Soup" within ".popular"
  
  Scenario: Listing of Quality Shows
    Given "Inflatable" by "Adam Hills" has an average rating of 5
    And "The Hotel" by "Mark Watson" has an average rating of 4
    And "Randy's Postcards from Purgatory" by "Heath McIvor" has an average rating of 4.5
    And "The Last Stand to Reason" by "Pajama Men" has an average rating of 4.5
    And "Rabbit Faced Story Soup" by "Laura Solon" has an average rating of 3
    And "1999" by "Sammy J" has an average rating of 4
    When I go to the home page
    Then I should see "Inflatable" within ".quality"
    And I should see "The Hotel" within ".quality"
    And I should see "Randy's Postcards from Purgatory" within ".quality"
    And I should see "The Last Stand to Reason" within ".quality"
    And I should see "1999" within ".quality"
    And I should not see "Rabbit Faced Story Soup" within ".quality"
  
