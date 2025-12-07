# User/Organizer Sign up

## Overview
The **sign up feature** enables users to create and access new accounts on the website by specifying a unique username, role, and a password. There will be one sign up page for all types of users.

## User Story: User/Organizer sign up
As a user/organizer, I want to enter a unique username, specify my role, and set a password, so that I can create and access my account.

## Acceptance Criteria
- **Scenario 1: Successful sign up as a user**
    Given I am on the sign up page
    And no user/organizer exists with username "JohnDoe"
    When I fill in my username with "JohnDoe"
    And I select user as my role
    And I fill in my password with "password123"
    And I click "Create Account"
    Then I should get a notification that my account was created successfully
    Then I should be on my user homepage

- **Scenario 2: Successful sign up as an organizer**
    Given I am on the sign up page
    And no user/organizer exists with username "JohnDoe"
    When I fill in my username with "JohnDoe"
    And I select organizer as my role
    And I fill in my password with "password123"
    And I click "Create Account"
    Then I should get a notification that my account was created successfully
    Then I should be on my organizer homepage

- **Scenario 3: Unsuccessful sign up as an user**
    Given I am on the sign up page
    And a user/organizer exists with username "JohnDoe"
    When I fill in my username with "JohnDoe"
    And I select user as my role
    And I fill in my password with "password123"
    And I click "Create Account"
    Then I should receive an error
    And the sign up page should refresh to blank

- **Scenario 4: Unsuccessful sign up as an organizer**
    Given I am on the sign up page
    And a user/organizer exists with username "JohnDoe"
    When I fill in my username with "JohnDoe"
    And I select organizer as my role
    And I fill in my password with "password123"
    And I click "Create Account"
    Then I should receive an error
    And the sign up page should refresh to blank

## MVC Outline
### Model
- User Model
    - Attributes:
        - `username:string`
        - `role:string`
        - `password:string`
        - `first_name:string`
        - `last_name:string`
        - `age:integer`
        - `gender:string`
  
### View
- `users/home.html.erb`
    - shows user's dashboard
    - displays upcoming itneraries
- `users/signup.html.erb`
    - displays empty sign up form with username, role, and password fields
    - submit button to POST
    - error message if fails
- `organizers/home.html.erb`
    - shows organizer's dashboard
    - displays upcoming itneraries and groups

### Controller
- UsersController
    - `show` action
        - displays user dashboard
    - `new` action - empty form
        - creates empty sign up
    - `create` action - submits sign up
        - create the user
        - authenticate the user


