Feature: Itinerary Privacy
    As an organizer
    I want to make an itinerary private and password protected
    So that only users I agree to can join the group

    As a user
    I want to join a private trip by entering a valid password 
    So that I can participate securely.

Background:
    Given an organizer exists with username "izzyadams11" and password "IloveCS123!"
    And the following itinerary exists:
        | title       | NYC Tour              |
        | description | Exploring NYC         |
        | location    | New York              |
        | start_date  | 2026-01-01            |
        | end_date    | 2026-01-14            |
        | trip_type   | Public                |
        | cost        | 2400                  |


# Organizer Changes Trip to Private
Scenario: Redirect after making trip private
    Given I am logged in as organizer "izzyadams11"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Private" from "Trip Type"
    And I enter "bigapple" as my trip password
    When I press "Save Changes"
    Then I should be on the itinerary page for "NYC Tour"

Scenario: Confirmation after making trip private
    Given I am logged in as organizer "izzyadams11"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Private" from "Trip Type"
    And I enter "bigapple" as my trip password
    When I press "Save Changes"
    Then I should see the message "Itinerary was successfully updated."

Scenario: Trip marked as private persists in database
    Given I am logged in as organizer "izzyadams11"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Private" from "Trip Type"
    And I enter "bigapple" as my trip password
    When I press "Save Changes"
    Then the itinerary "NYC Tour" should have trip_type "Private" in the database
    And the itinerary "NYC Tour" should have an encrypted password in the database

# User joins Private Trip
Scenario: User redirect after joining private trip
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    And I visit the join page for "NYC Tour"
    And I enter "bigapple" as the trip password
    When I press "Join Trip"
    Then I should be on the itinerary page for "NYC Tour"

Scenario: User sees confirmation after joining private trip
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    And I visit the join page for "NYC Tour"
    And I enter "bigapple" as the trip password
    When I press "Join Trip"
    Then I should see the message "You have joined the trip successfully."

Scenario: User added to joined trips after successful join
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    And I have joined the trip "NYC Tour" with password "bigapple"
    Then I should see "NYC Tour" in my joined trips list

# Wrong Password
Scenario: User joins private trip with wrong password
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    When I visit the join page for "NYC Tour"
    And I enter "wrongpass" as the trip password
    And I press "Join Trip"
    Then I should see the message "Incorrect trip password."
    And I should not see "NYC Tour" in my joined trips list

# Change back to public trip
Scenario: Redirect after making trip public
    Given I am logged in as organizer "izzyadams11"
    And the itinerary "NYC Tour" is private with password "bigapple"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Public" from "Trip Type"
    And I press "Save Changes"
    Then I should be on the itinerary page for "NYC Tour"

Scenario: Confirmation message after making trip public
    Given I am logged in as organizer "izzyadams11"
    And the itinerary "NYC Tour" is private with password "bigapple"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Public" from "Trip Type"
    And I press "Save Changes"
    Then I should see the message "Itinerary was successfully updated."

Scenario: Trip marked as public persists in database
    Given I am logged in as organizer "izzyadams11"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Public" from "Trip Type"
    When I press "Save Changes"
    Then the itinerary "NYC Tour" should have trip_type "Public" in the database

