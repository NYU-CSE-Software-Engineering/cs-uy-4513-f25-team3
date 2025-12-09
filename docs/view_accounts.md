# Account Management

## Overview
The **view accounts feature** enables admin users to view all accounts in the system, delete accounts, and modify user roles.
This is necessary for managing security, enforcing policies, and maintaining the system’s integrity.


## User Story: View Accounts
As an administrator, I want to view and manage user accounts so that I can maintain system security and integrity.

## Acceptance Criteria
- **Scenario 1: View all accounts**
    Given I am logged in as an administrator
    And the following accounts exist
    | username | role |
    | "izzyadams11" | "user" |
    | "rheanayar7" | "organizer"|
    When I navigate to the accounts page
    Then I should see information for "izzyadams11"
    And I should see information for "rheanayar7"


- **Scenario 2: Successful account deletion**
    Given I am logged in as an administrator
    And a user with username "izzyadams11" exists
    When I select that account 
    And I click "Delete"
    And I choose "Confirm" on the confirmation prompt
    Then the system should remove that user account
    And the Accounts page should not display "izzyadams11"


- **Scenario 3: Cancel account deletion** 
    Given I am logged in as an administrator
    And a user with username "izzyadams11" exists
    When I select that account 
    And I click "Delete"
    And I choose "Cancel" on the confirmation prompt
    Then the account should still exist
    And the Accounts page should display "izzyadams11"


- **Scenario 4: Deleting a nonexistent account** 
    Given I am logged in as an administrator
    And no user with username "ghostUser" exists
    When I navigate to the Accounts page
    Then the Accounts page should not display "ghostUser"


- **Scenario 5: Trying to delete an account as a user** 
    Given I am logged in as a regular user
    When I navigate to the Accounts page
    I should be denied access


- **Scenario 6: Successful modification of account role**
    Given I am logged in as an administrator
    And a user with username "izzyadams11" and role "user" exists
    When I select that account 
    And I click "Modify Role"
    And I change the role to "organizer"
    And I choose "Confirm" on the confirmation prompt
    Then the account "izzyadams11" should have role "organizer"




## MVC Outline
### Model
- User Model
    - Attributes:
        - `user_id:string`
        - `username:string`
        - `password:string`
        - `first_name:string`
        - `last_name:string`
        - `age:integer`
        - `gender:string`
        - `role:string`
  
### View
- `admin/accounts.html.erb`
    - displays all accounts that exist in the system


### Controller
- AdminController
    - `index` action
        - displays all users in the system
    - `destroy` action
        - destroys chosen user account
