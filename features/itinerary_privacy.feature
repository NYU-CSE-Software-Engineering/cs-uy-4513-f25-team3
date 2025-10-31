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

Scenario: Organizer makes trip private with password
    Given I am logged in as organizer "izzyadmams11"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Private" from "Trip Type"
    And I enter "bigapple" as my trip password
    And I press "Save Changes"
    Then I should be on the itinerary page for "NYC Tour"
    And I should see the message "Itinerary was successfully updated."
    And I should see "Private"
    And users must enter a password to join

Scenario: User joins private trip with correct password
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    When I visit the join page for "NYC Tour"
    And I enter "bigapple" as the trip password
    And I press "Join Trip"
    Then I should be on the itinerary page for "NYC Tour"
    And I should see the message "You have joined the trip successfully."
    And I should see "NYC Tour" in my joined trips list

Scenario: User joins private trip with wrong password
    Given the itinerary "NYC Tour" is private with password "bigapple"
    And I am logged in as user "janedoe"
    When I visit the join page for "NYC Tour"
    And I enter "wrongpass" as the trip password
    And I press "Join Trip"
    Then I should be on the join page for "NYC Tour"
    And I should see the message "Incorrect trip password."
    And I should not see "NYC Tour" in my joined trips list

  Scenario: Organizer makes trip public again
    Given I am logged in as organizer "izzyadmams11"
    And the itinerary "NYC Tour" is private with password "bigapple"
    And I am on the itinerary settings page for "NYC Tour"
    And I select "Public" from "Trip Type"
    And I press "Save Changes"
    Then I should be on the itinerary page for "NYC Tour"
    And I should see the message "Itinerary was successfully updated."
    And I should see "Public"
    And users no longer need a password to join