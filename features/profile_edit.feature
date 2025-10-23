Feature: Profile Edit — User Management and Authentication
    As a registered user
    I want to change my first name, last name, username, password, age, or gender
    So that my profile information stays accurate and personalized

Background:
    Given the following Users exist:
        | UserID | FirstName | LastName | Username | Password | Age | Gender |
        | 1      | John      | Doe      | john123  | pass123  | 25  | Male   |
        | 2      | Jane      | Doe      | janey    | hello22  | 20  | Female |
    And I am UserID 1

# HAPPY PATHS

Scenario: Successfully change username
    Given I am on the profile edit page
    When I enter my current password correctly
    And I enter "john456" as my new unique username
    And I press "Save Changes"
    Then my username should be updated to "john456"
    And I should see a success confirmation message

Scenario: Successfully change password
    Given I am on the profile edit page
    When I enter my current password correctly
    And I enter "newpass789" as my new password
    And I confirm it by typing "newpass789" again
    And I press "Save Changes"
    Then I should be able to log in only with "newpass789"
    And the old password should no longer work

Scenario: Successfully change age
    Given I am on the profile edit page
    When I update my age to 26
    And I press "Save Changes"
    Then my age should be updated to 26 on my profile

Scenario: Successfully change first and last name
    Given I am on the profile edit page
    When I update my first name to "Arthur"
    And I update my last name to "Morgan"
    And I press "Save Changes"
    Then my full name should be displayed as "Arthur Morgan" on my profile

Scenario: Successfully change gender
    Given I am on the profile edit page
    When I update my gender to "Female"
    And I press "Save Changes"
    Then my gender should be updated to "Female" on my profile
