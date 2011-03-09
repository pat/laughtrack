@no-txn
Feature: Manage Performer Information
  In order to have accurate information
  As an administrator
  I want to be able to edit performer details
  
  Background:
    Given a festival "MICF" in 2011
      And an admin "master@laughtrack.com.au"
      And I am logged in as admin "master@laughtrack.com.au"
  
  Scenario: Searching for Performers
    Given a performer "Danny Bhoy"
      And a performer "Danny McGinlay"
      And the performer indexes are processed
    When  I go to the admin performers page
      And I fill in "Search" with "McGinlay" within "#content"
      And I press "Search" within "#content"
    Then  I should see "Danny McGinlay"
      But I should not see "Danny Bhoy"
  
  Scenario: Editing Performer Information
    Given a performer "Scod Edgar"
      And the performer indexes are processed
    When  I go to the admin performer page for "Scod Edgar"
      And I fill in "Name" with "Scott Edgar"
      And I press "Save Changes"
    Then  I should see "Scott Edgar"
      But I should not see "Scod Edgar"
  
