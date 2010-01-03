@no-txn
Feature: Manage Performer Information
  In order to have accurate information
  As an administrator
  I want to be able to edit performer details
  
  Scenario: Searching for Performers
    Given a performer "Danny Bhoy"
    And a performer "Danny McGinlay"
    And the performer indexes are processed
    And I have signed in with "user@domain.com/password"
    When I go to the admin performers page
    And I fill in "Search" with "McGinlay"
    And I press "Search"
    Then I should see "Danny McGinlay"
    But I should not see "Danny Bhoy"
  
  Scenario: Editing Performer Information
    Given a performer "Scod Edgar"
    And the performer indexes are processed
    And I have signed in with "user@domain.com/password"
    When I go to the admin performer page for "Scod Edgar"
    And I fill in "Name" with "Scott Edgar"
    And I press "Save Changes"
    Then I should see "Scott Edgar"
    But I should not see "Scod Edgar"
  
