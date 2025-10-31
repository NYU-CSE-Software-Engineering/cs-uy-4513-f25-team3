# Login Management

## Overview
The **login feature** enables users to access their account by entering the correct username and password.
There will be one login page for all types of users. This feature allows for privacy and access to individual data.


## User Story: Login 
As a user/organizer, I want to enter my username and password, so that I can access my account.

## Acceptance Criteria
- **Scenario 1: Successful login as a user**
    Given I am on the login page
    And a user exists with "Username" "izzyadams11"
    And a user exists with "Password" "IloveCS123!"
    When I fill in "Username" with "izzyadams11"
    And I fill in "Password" with "IloveCS123!"
    And I click "Submit"
    Then I should be on my user homepage

- **Scenario 2: Successful login as an organizer** 
    Given I am on the login page
    And an organizer exists with "Username" "rheanayar"
    And an organizer exists with "Password" "IloveDS123!"
    When I fill in "Username" with "rheanayar"
    And I fill in "Password" with "IloveDS123!"
    And I click "Submit"
    Then I should be on my organizer homepage

- **Scenario 3: Unsuccessful login** 
    Given I am on the login page
    And a user exists with "Username" "izzyadams11"
    And a user exists with "Password" "IloveCS123!"
    When I fill in "Username" with "izzyadams11"
    And I fill in "Password" with "IloveDS!"
    And I click "Submit"
    Then I should receive an error
    And the login page should refresh to blank

- **Scenario 4: Login with blank field** 
    Given I am on the login page
    And a user exists with "Username" "izzyadams11"
    And a user exists with "Password" "IloveCS123!"
    When I fill in "Username" with "izzyadams11"
    And I fill in "Password" with ""
    And I click "Submit"
    Then I should receive an error
    And the login page should refresh to blank



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
  
### View
- `users/home.html.erb`
    - shows user's dashboard
    - displays upcoming itneraries
- `sessions/new.html.erb`
    - displays empty login form with username and password fields
    - submit button to POST
    - error message if fails
- `organizers/home.html.erb`
    - shows organizer's dashboard
    - displays upcoming itneraries and groups

### Controller
- UsersController
    - `show` action
        - displays user dashboard
- OrganizersController
    - `show` action
        - displays organizer dashboard
- SessionController
   - `new` action - empty form
        - creates empty login
    - `create` action - submits login
        - authenticate the user