Feature: Joining an itinerary
    As a user
    I want to join public and private itinerary groups
    So that I can participate in trips with other users

    Background:
    Given the following Users exist for sign up:
        | Username | Password | Role |
        | chris    | password | user |
        | alice    | password | user |

    And the following Itinerary Groups exist:
        | Title               | Description     | Location | Start Date  | End Date    | Cost | Is Private | Password  | Organizer |
        | Public Europe Trip  | Fun Europe Trip | Europe   | 2026-01-01  | 2026-01-10  | 2000 | false      |           | chris     |
        | Secret Korea Trip   | Korea Adventure | Seoul    | 2026-02-01  | 2026-02-15  | 3500 | true       | korea123  | alice     |

    @core
    Scenario: Successfully joining a public itinerary
        Given I am a signed-in user as "chris"
        And I am on the itinerary details page for "Public Europe Trip"
        When I press "Join Trip"
        Then I should see the success message "You have joined this itinerary"
        And I should be listed as an attendee of "Public Europe Trip"

    @core
    Scenario: Successfully joining a private itinerary with the correct password
        Given I am a signed-in user as "chris"
        And I am on the itinerary details page for "Secret Korea Trip"
        When I press "Join Trip"
        Then I should be on the join itinerary page for "Secret Korea Trip"
        When I fill in "Password" with "korea123"
        And I press "Join"
        Then I should see the success message "You have joined this itinerary"
        And I should be listed as an attendee of "Secret Korea Trip"
        And I should see the itinerary details for "Secret Korea Trip"

    Scenario: Failing to join a private itinerary with the wrong password
        Given I am a signed-in user as "chris"
        And I am on the itinerary details page for "Secret Korea Trip"
        When I press "Join Trip"
        Then I should be on the join itinerary page for "Secret Korea Trip"
        When I fill in "Password" with "wrongpassword"
        And I press "Join"
        Then I should see the error message "Incorrect password"
        And I should not be listed as an attendee of "Secret Korea Trip"
        And I should not see the itinerary details for "Secret Korea Trip"

    Scenario: Preventing duplicate joins when user has already joined
        Given I am a signed-in user as "chris"
        And I have already joined the itinerary "Public Europe Trip"
        And I am on the itinerary details page for "Public Europe Trip"
        When I press "Join Trip"
        Then I should see the message "You are attending this itinerary"
        And I should not be added as a duplicate attendee for "Public Europe Trip"

    Scenario: Unauthenticated user trying to join an itinerary
        Given I am not signed in
        When I try to join the itinerary "Public Europe Trip"
        Then I should be on the sign in page
        And I should see the message "Please log in to continue"
