Feature: Login
    As an administrator, 
    I want to view and manage user accounts 
    so that I can maintain system security and integrity.

Background:
    Given the following accounts exist:
        | username | role |
        | izzyadams11 | user |
        | rheanayar7 | organizer|

Scenario: View all accounts
    Given I am logged in as an administrator
    When I navigate to the Accounts page
    Then the Accounts page should display "izzyadams11"
    And the Accounts page should display "rheanayar7"


Scenario: Successful account deletion
    Given I am logged in as an administrator
    When I navigate to the Accounts page
    And I click the "Delete" button for "izzyadams11"
    Then the Accounts page should not display "izzyadams11"


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
    When I navigate to the Accounts page
    And I click the "Update Role" button for "rheanayar7"
    And I change the role to "user" for "rheanayar7"
    Then the account "rheanayar7" should have role "user"

