Feature: Editing Itinerary
	As a user
	I want to edit the description, location, start date, end date, trip type, and/or trip cost
	So that the itinerary can stay updated with any recent changes

Background:
	Given I am a signed-in user
	And the following itinerary exists:
        | title       | NYC Tour              |
		| description | Exploring NYC         |
		| location    | New York              |
		| start_date  | 2026-01-01            |
		| end_date    | 2026-01-14            |
		| is_private  | Public                |
		| cost        | 2400                  |


#Happy Paths


Scenario: Fields are pre-populated and editable
	Given I am on the itinerary settings page for "NYC Tour"
	Then I should see an editable "Title" field prefilled with "NYC Tour"
	And I should see an editable "Description" field prefilled with "Exploring NYC"
	And I should see an editable "Location" field prefilled with "New York"
	And I should see an editable "Start Date" field prefilled with "2026-01-01"
	And I should see an editable "End Date" field prefilled with "2026-01-14"
	And I should see an editable "Trip Type" selector prefilled with "Public"
	And I should see an editable "Trip Cost" field prefilled with "2400"

Scenario: Successfully update all editable fields
	Given I am on the itinerary settings page for "NYC Tour"
    When I fill in "Title" with "New York Adventure"
    And I fill in "Description" with "A fun trip to NYC"
    And I fill in "Location" with "Manhattan"
    And I fill in "Start Date" with "2026-02-01"
    And I fill in "End Date" with "2026-02-14"
    And I select "Private" from "Trip Type"
    And I fill in "Trip Cost" with "3000"
    And I press "Save Changes"
    Then I should be on the itinerary page for "New York Adventure"
    And I should see the message "Itinerary was successfully updated."
    And I should see "A fun trip to NYC"
    And I should see "Manhattan"
    And I should see "Feb 1, 2026"
	And I should see "Feb 14, 2026"
    And I should see "Private"
    And I should see "$3000"



#Sad Paths


Scenario: End date before start date - shows an error
 	Given I am on the itinerary settings page for "NYC Tour"
    When I fill in "Start Date" with "2026-05-05"
    And I fill in "End Date" with "2026-05-01"
    And I press "Save Changes"
    Then I should see the error "End date must be on or after Start date"


Scenario: Missing title - shows an error
	Given I am on the itinerary settings page for "NYC Tour"
    When I fill in "Title" with ""
    And I press "Save Changes"
    Then I should see the error "Title can't be blank"



Scenario: Negative trip cost - shows an error
	Given I am on the itinerary settings page for "NYC Tour"
	When I fill in "Trip Cost" with "-100"
	And I press "Save Changes"
	Then I should see the error "Cost must be greater than or equal to 0"