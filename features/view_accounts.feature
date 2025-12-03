Feature: Login
    As an administrator, 
    I want to view and manage user accounts 
    so that I can maintain system security and integrity.

Scenario: View all accounts
    Given I am logged in as an administrator
    And the following accounts exist
    | username | role |
    | "izzyadams11" | "user" |
    | "rheanayar7" | "organizer"|
    When I navigate to the accounts page
    Then I should see information for "izzyadams11"
    And I should see information for "rheanayar7"


Scenario: Successful account deletion
    Given I am logged in as an administrator
    And a user with username "izzyadams11" exists
    When I select that account 
    And I click "Delete"
    And I choose "Confirm" on the confirmation prompt
    Then the system should remove that user account
    And the Accounts page should not display "izzyadams11"


Scenario: Cancel account deletion
    Given I am logged in as an administrator
    And a user with username "izzyadams11" exists
    When I select that account 
    And I click "Delete"
    And I choose "Cancel" on the confirmation prompt
    Then the account should still exist
    And the Accounts page should display "izzyadams11"


Scenario: Deleting a nonexistent account
    Given I am logged in as an administrator
    And no user with username "ghostUser" exists
    When I navigate to the Accounts page
    Then the Accounts page should not display "ghostUser"


Scenario: Trying to delete an account as a user
    Given I am logged in as a user
    When I navigate to the Accounts page
    Then I should be denied access


Scenario: Successful modification of account role
    Given I am logged in as an administrator
    And a user with username "izzyadams11" and role "user" exists
    When I select that account 
    And I click "Modify Role"
    And I change the role to "organizer"
    And I choose "Confirm" on the confirmation prompt
    Then the account "izzyadams11" should have role "organizer"

