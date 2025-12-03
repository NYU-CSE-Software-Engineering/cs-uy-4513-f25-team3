Feature: Login
    As an administrator, 
    I want to view and manage user accounts 
    so that I can maintain system security and integrity.

Background:
    The following accounts exist
    | username | role |
    | "izzyadams11" | "user" |
    | "rheanayar7" | "organizer"|

Scenario: View all accounts
    Given I am logged in as an administrator
    When I navigate to the Accounts page
    And the Accounts page should display "izzyadams11"
    And the Accounts page should display "rheanayar7"


Scenario: Successful account deletion
    Given I am logged in as an administrator
    And I click "Delete" for "izzyadams11"
    And I click "Confirm"
    Then the Accounts page should not display "izzyadams11"


Scenario: Cancel account deletion
    Given I am logged in as an administrator
    And I click "Delete" for "izzyadams11"
    And I click "Cancel"
    Then the Accounts page should display "izzyadams11"


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
    And I click "Modify Role" for "izzyadams11"
    And I change the role to "organizer"
    And I click "Confirm"
    Then the account "izzyadams11" should have role "organizer"

