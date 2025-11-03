Feature: Login
    As a user/organizer
    I want to enter my username and password
    So that I can access my account

    Scenario: Successful login as a user
        Given I am on the login page
        And a user exists with "Username" "izzyadams11"
        And a user exists with "Password" "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with "IloveCS123!"
        And I click "Submit"
        Then I should be on my user homepage

    Scenario: Successful login as an organizer
        Given I am on the login page
        And an organizer exists with "Username" "rheanayar"
        And an organizer exists with "Password" "IloveDS123!"
        When I fill in "Username" with "rheanayar"
        And I fill in "Password" with "IloveDS123!"
        And I click "Submit"
        Then I should be on my organizer homepage

    Scenario: Unsuccessful login
        Given I am on the login page
        And a user exists with "Username" "izzyadams11"
        And a user exists with "Password" "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with "IloveDS!"
        And I click "Submit"
        Then I should receive an error
        And the login page should refresh to blank

    Scenario: Login with blank field
        Given I am on the login page
        And a user exists with "Username" "izzyadams11"
        And a user exists with "Password" "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with ""
        And I click "Submit"
        Then I should receive an error
        And the login page should refresh to blank