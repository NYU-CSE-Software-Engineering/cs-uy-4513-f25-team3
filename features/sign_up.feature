Feature: User Sign Up — Account Creation
    As a new visitor
    I want to create an account
    So that I can log in and use the system

Background:
    Given the following Users exist:
        | UserID | Username | Password | Role  |
        | 1      | john123  | pass123  | user  |
        | 2      | janedoe  | hello22  | admin |
    And I am on the sign up page

# HAPPY PATHS

Scenario: Successfully sign up with valid information
    When I enter "freddy" into the "Username" field
    And I select "user" from the "Role" dropdown
    And I enter "mypassword123" into the "Password" field
    And I enter "mypassword123" into the "Password Confirmation" field
    And I press "Create Account"
    Then I should see a message saying "Account created successfully"
    And I should be logged in as "freddy"

Scenario: Successfully sign up as an organizer
    When I enter "bonney" into the "Username" field
    And I select "organizer" from the "Role" dropdown
    And I enter "pass" into the "Password" field
    And I enter "pass" into the "Password Confirmation" field
    And I press "Create Account"
    Then I should see "Account created successfully"
    And I should be logged in as "bonney"


# SAD PATHS

Scenario: Fail sign up due to username already taken
    When I enter "john123" into the "Username" field
    And I select "user" from the "Role" dropdown
    And I enter "newpass456" into the "Password" field
    And I enter "newpass456" into the "Password Confirmation" field
    And I press "Create Account"
    Then the sign up page should refresh
    And I should see an error saying "Username already taken"

Scenario: Fail sign up due to password confirmation mismatch
    When I enter "newuser" into the "Username" field
    And I select "user" from the "Role" dropdown
    And I enter "goodpass" into the "Password" field
    And I enter "WRONGpass" into the "Password Confirmation" field
    And I press "Create Account"
    Then I should see an error saying "Password confirmation does not match"
    And the account should not be created

Scenario: Fail sign up due to missing required fields
    When I leave "Username" blank
    And I press "Create Account"
    Then I should see an error saying "Username can't be blank"
    And I should see an error saying "Password can't be blank"