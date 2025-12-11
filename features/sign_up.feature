Feature: User Sign Up — Account Creation
  As a new visitor
  I want to create an account
  So that I can log in and use the system

Background:
  Given the following Users exist for sign up:
      | UserID | Username | Password | Role  |
      | 1      | john123  | pass123  | user  |
      | 2      | janedoe  | hello22  | admin |
  And I am on the sign up page

# HAPPY PATHS

Scenario: Successfully sign up with valid information
  When I fill in "freddy" for the sign up username
  And I select "user" for the sign up role
  And I fill in "mypassword123" for the sign up password
  And I fill in "mypassword123" for the sign up password confirmation
  And I click the "Create Account" button for sign up
  Then I should see the sign up success message "Account created successfully"
  And I should be logged in as sign up user "freddy"

Scenario: Successfully sign up as an organizer
  When I fill in "bonney" for the sign up username
  And I select "organizer" for the sign up role
  And I fill in "pass" for the sign up password
  And I fill in "pass" for the sign up password confirmation
  And I click the "Create Account" button for sign up
  Then I should see the sign up success message "Account created successfully"
  And I should be logged in as sign up user "bonney"

# SAD PATHS

Scenario: Fail sign up due to username already taken
  When I fill in "john123" for the sign up username
  And I select "user" for the sign up role
  And I fill in "newpass456" for the sign up password
  And I fill in "newpass456" for the sign up password confirmation
  And I click the "Create Account" button for sign up
  Then the sign up page should reload
  And I should see the sign up error "Username has already been taken"

Scenario: Fail sign up due to password confirmation mismatch
  When I fill in "newuser" for the sign up username
  And I select "user" for the sign up role
  And I fill in "goodpass" for the sign up password
  And I fill in "WRONGpass" for the sign up password confirmation
  And I click the "Create Account" button for sign up
  Then I should see the sign up error "Password confirmation does not match"
  And the sign up account should not be created

Scenario: Fail sign up due to missing required fields
  When I leave the sign up username blank
  And I click the "Create Account" button for sign up
  Then I should see the sign up error "Username can't be blank"
  And I should see the sign up error "Password can't be blank"
