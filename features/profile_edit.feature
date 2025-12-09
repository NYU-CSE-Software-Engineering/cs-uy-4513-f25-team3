Feature: Profile Edit — User Management and Authentication
    As a registered user
    I want to change my first name, last name, username, password, age, or gender
    So that my profile information stays accurate and personalized

Background:

    Given the following Users exist:
        | UserID | FirstName | LastName | Username | Password | Role       | Age | Gender |
        | 1      | John      | Doe      | john123  | pass123  | user       | 25  | Male   |
        | 2      | Jane      | Doe      | janey    | hello22  | organizer  | 20  | Female |
    And I am UserID 1
    Given I am on the profile edit page


# HAPPY PATHS

Scenario: Successfully change username
    When I enter my current password "pass123" correctly
    And I enter "john456" as my new unique username
    And I press "Save Changes" for editing the profile
    Then my username should be updated to "john456"

Scenario: Successfully change password
    When I enter my current password "pass123" correctly
    And I enter "newpass789" as my new password
    And I confirm it by typing "newpass789" again
    And I press "Save Changes" for editing the profile
    Then I should be able to log in only with "newpass789"
    And the old password should no longer work

Scenario: Successfully change age
    When I update my age to 26
    And I enter my current password "pass123" correctly
    And I press "Save Changes" for editing the profile
    Then my age should be updated to 26 on my profile

Scenario: Successfully change first and last name
    When I update my first name to "Arthur"
    And I update my last name to "Morgan"
    And I enter my current password "pass123" correctly
    And I press "Save Changes" for editing the profile
    Then my full name should be displayed as "Arthur Morgan" on my profile

Scenario: Successfully change gender
    When I update my gender to "Female"
    And I enter my current password "pass123" correctly
    And I press "Save Changes" for editing the profile
    Then my gender should be updated to "Female" on my profile

# SAD PATHS

Scenario: Attempt to update password but confirmation does not match
    When I enter my current password "pass123" correctly
    And I enter "newpass123" as my new password
    And I confirm it by typing "WRONGpass123" again
    And I press "Save Changes" for editing the profile
    Then my password should still be "pass123"

Scenario: Attempt to view another user's profile page
    When I try to visit /edit/2
    Then I should not be able to view the page /edit/2
    And I should be back on /edit/1