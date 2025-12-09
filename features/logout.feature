Feature: Logout - User Management and Authentication
    As a user/organizer that is logged in
    I want to log out of my account
    So that no one else can access my information from this device

Background:
    Given the following Users exist:
        | UserID | FirstName | LastName | Username    | Password   | Age | Gender | Role | Password Confirmation |
        | 1      | John      | Doe      | john123     | pass123    | 25  | Male   | user | pass123 |
        | 2      | Jane      | Doe      | janey       | hello22    | 20  | Female | user | hello22 |
        | 3      | Izzy      | Adams    | izzyadams11 | IloveCS123 | 21  | Female | user | IloveCS123 |
        | 4      | Rhea      | Nayar    | rheanayar   | IloveDS123 | 23  | Female | user | IloveDS123 |
    And I am UserID 1
    And I am on the "itineraries" page

Scenario: Successful logout
    When I press "Logout"
    Then I should see the message "You have been logged out"
    And I should be on the login page
    And I should not have an active session

Scenario: Logout attempt without being logged in
    Given I am not logged in
    Then I should not see a "Logout" button
    And I should not have an active session

Scenario: Access page after logout
    When I press "Logout"
    When I try to visit the itineraries page
    Then I should be on the login page
    And I should see the message "Please log in to continue"
    
Scenario: No logout button after session expires
    Given my session has expired
    Then I should not see a "Logout" button
    And I should be on the login page