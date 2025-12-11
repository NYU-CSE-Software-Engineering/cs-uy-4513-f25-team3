Feature: View Group Users
	As a user
	I want to view the group attending an itinerary
	So I can know the people I am going on a trip with

Background:
	Given the following users exist:
		| first_name | last_name | username | password  | role      |
		| Alice      | Smith     | alice_s  | Pass123!  | organizer |
		| Bob        | Jones     | bob_j    | Pass123!  | user      |
		| Carol      | Wilson    | carol_w  | Pass123!  | user      |
		| David      | Brown     | david_b  | Pass123!  | user      |
	And I am logged in as "bob_j" with password "Pass123!"

#Happy Paths
Scenario: View members in a public group I belong to
	Given the following itinerary group exists:
		| title           | Fun Adventure         |
		| description     | Having Fun				|
		| organizer       | alice_s                  |
		| is_private      | false                    |
	And I am a member of the group "Fun Adventure"
	And "carol_w" is a member of the group "Fun Adventure"
	When I visit the itinerary page for "Fun Adventure"
	Then I should see "Attendees"
	And I should see "alice_s"
	And I should see "bob_j"
	And I should see "carol_w"

Scenario: View members as the organizer
	Given I am logged in as "alice_s" with password "Pass123!"
	And I have created an itinerary group titled "Fun Adventure"
	And "bob_j" is a member of the group "Fun Adventure"
	And "carol_w" is a member of the group "Fun Adventure"
	And "david_b" is a member of the group "Fun Adventure"
	When I visit the itinerary page for "Fun Adventure"
	Then I should see "Attendees"
	And I should see "alice_s"
	And I should see "bob_j"
	And I should see "carol_w"
	And I should see "david_b"

Scenario: View group with only organizer (no other members)
	Given I am logged in as "alice_s" with password "Pass123!"
	And I have created an itinerary group titled "New Trip"
	When I visit the itinerary page for "New Trip"
	Then I should see "Attendees"
	And I should see "alice_s"

Scenario: Member list updates when new member joins
	Given the following itinerary group exists:
		| title       | Fun Adventure  |
		| description | Having Fun     |
		| organizer   | alice_s        |
		| is_private  | false          |
	And I am a member of the group "Fun Adventure"
	When I visit the itinerary page for "Fun Adventure"
	Then I should see "alice_s"
	And I should see "bob_j"
	And I should not see "carol_w"
	When "carol_w" joins the group "Fun Adventure"
	And I visit the itinerary page for "Fun Adventure"
	Then I should see "alice_s"
	And I should see "bob_j"
	And I should see "carol_w"

Scenario: Member list updates when a member leaves
	Given the following itinerary group exists:
		| title       | Fun Adventure  |
		| description | Having fun     |
		| organizer   | alice_s        |
		| is_private  | false          |
	And I am a member of the group "Fun Adventure"
	And "carol_w" is a member of the group "Fun Adventure"
	And "david_b" is a member of the group "Fun Adventure"
	When I visit the itinerary page for "Fun Adventure"
	Then I should see "alice_s"
	And I should see "bob_j"
	And I should see "carol_w"
	And I should see "david_b"
	When "carol_w" leaves the group "Fun Adventure"
	And I visit the itinerary page for "Fun Adventure"
	Then I should see "alice_s"
	And I should see "bob_j"
	And I should see "david_b"
	And I should not see "carol_w"

Scenario: View members in multiple different groups
	Given the following itinerary group exists:
		| title       | Paris Trip     |
		| description | Visit Paris    |
		| organizer   | alice_s        |
		| is_private  | false          |
	And I am a member of the group "Paris Trip"
	And "carol_w" is a member of the group "Paris Trip"
	And the following itinerary group exists:
		| title       | Tokyo Trip     |
		| description | Visit Tokyo    |
		| organizer   | carol_w        |
		| is_private  | false          |
	And I am a member of the group "Tokyo Trip"
	And "david_b" is a member of the group "Tokyo Trip"
	When I visit the itinerary page for "Paris Trip"
	Then I should see "alice_s"
	And I should see "bob_j"
	And I should see "carol_w"
	And I should not see "david_b"
	When I visit the itinerary page for "Tokyo Trip"
	Then I should see "carol_w"
	And I should see "bob_j"
	And I should see "david_b"
	And I should not see "alice_s"

#Sad Paths
Scenario: Cannot view members of a private group I'm not in
	Given the following itinerary group exists:
		| title       | Secret Trip    |
		| description | Private 	   |
		| organizer   | alice_s        |
		| is_private  | true           |
		| password    | secret123      |
	And "carol_w" is a member of the group "Secret Trip"
	When I attempt to visit the itinerary page for "Secret Trip"
	Then I should see an error message
	And I should not see "carol_w"

Scenario: Cannot view members when not logged in
	Given the following itinerary group exists:
		| title       | Public Trip    |
		| description | Open           |
		| organizer   | alice_s        |
		| is_private  | false          |
	And "carol_w" is a member of the group "Public Trip"
	And I am logged out
	When I attempt to visit the itinerary page for "Public Trip"
	Then I should be redirected to the login page
	And I should not see "carol_w"

Scenario: Cannot view non-existent group
	When I attempt to visit the itinerary page for "Fake Trip"
	Then I should see an error message
	And I should see "not found" or "doesn't exist"

