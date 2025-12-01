# Login Management

## Overview
The **delete accounts feature** enables admin users to remove any account from the system.
This is necessary for managing security, enforcing policies, and maintaining the system’s integrity.


## User Story: Delete Accounts
As an administrator, I want to delete user accounts so that I can maintain system security and integrity.

## Acceptance Criteria
- **Scenario 1: Successful account deletion**
    Given I am logged in as an administrator
    And a user with username "izzyadams11" and password "IloveCS123!" is logged in
    When I select that user account 
    And I click "Delete"
    And I choose "Confirm" on the confirmation prompt
    Then the system should permanently remove that user account
    And the user should be logged out on their next action


- **Scenario 2: Cancel account deletion** 
    Given I am logged in as an administrator
    And a user with username "izzyadams11" and password "IloveCS123!" is logged in
    When I select that user account 
    And I click "Delete"
    And I choose "Cancel" on the confirmation prompt
    Then the user account should still exist in the system
    And the user should still be logged in 


- **Scenario 3: Deleting a nonexistent account** 
    Given I am logged in as an administrator
    And no user with username "ghostUser" exists
    Then this account should not appear on the accounts page


- **Scenario 4: Trying to delete an account as a user** 
    Given I am logged in as a regular user
    I should not be able to access the accounts page




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
