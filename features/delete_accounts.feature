Feature: Login
    As an administrator
    I want to delete user accounts 
    So that I can maintain system security and integrity.

    Scenario: Successful account deletion
        Given I am logged in as an administrator
        And a user with username "izzyadams11" and password "IloveCS123!" is logged in
        When I select that user account 
        And I click "Delete"
        And I choose "Confirm" on the confirmation prompt
        Then the system should permanently remove that user account
        And the user should be logged out on their next action


    Scenario: Cancel account deletion
        Given I am logged in as an administrator
        And a user with username "izzyadams11" and password "IloveCS123!" is logged in
        When I select that user account 
        And I click "Delete"
        And I choose "Cancel" on the confirmation prompt
        Then the user account should still exist in the system
        And the user should still be logged in 


    Scenario:
        Given I am logged in as an administrator
        And no user with username "ghostUser" exists
        Then this account should not appear on the accounts page

    Scenario: Trying to delete an account as a user 
        Given I am logged in as a user
        Then I should not be able to access the accounts page

