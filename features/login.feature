Feature: Login
    As a user/organizer
    I want to enter my username and password
    So that I can access my account

    Scenario: Successful login as a user
        Given I am on the login page
        And a user exists with username "izzyadams11" and password "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with "IloveCS123!"
        And I click "Login"
        Then I should be on the itineraries page

    Scenario: Successful login as an organizer
        Given I am on the login page
        And an organizer exists with username "rheanayar" and password "IloveDS123!"
        When I fill in "Username" with "rheanayar"
        And I fill in "Password" with "IloveDS123!"
        And I click "Login"
        Then I should be on the itineraries page

    Scenario: Unsuccessful login
        Given I am on the login page
        And a user exists with username "izzyadams11" and password "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with "IloveDS!"
        And I click "Login"
        Then I should receive an error
        And the login page should refresh to blank

    Scenario: Login with blank field
        Given I am on the login page
        And a user exists with username "izzyadams11" and password "IloveCS123!"
        When I fill in "Username" with "izzyadams11"
        And I fill in "Password" with ""
        And I click "Login"
        Then I should receive an error
        And the login page should refresh to blank