Feature: Group Chat — Communication Management
    As a member of an itinerary group
    I want to view, send, and edit messages with clear relevant details
    So that I can communicate effectively with my group

Background:
    Given the following Users exist:
        | UserID | Username |
        | 1      | alex     |
        | 2      | casey    |
        | 3      | jordan   |
    And the following ItineraryGroups exist:
        | ItineraryGroupID | GroupName |
        | 10               | A         | 
    And the following Messages exist:
        | MessageID | UserID | ItineraryGroupID | Text                      | Time                     |
        | 101       | 2      | 10               | Landing at 5pm            | 2025-10-22T16:30:00Z     | 
        | 102       | 3      | 10               | Meet in lobby at 6:45     | 2025-10-22T17:10:00Z     | 
        | 103       | 1      | 10               | On my way                 | 2025-10-22T17:15:00Z     | 
    And I am UserID 1
    And I am on the group chat for ItineraryGroupID 10


@message_conents
Rule: Message_conents
    Scenario: Send a non-empty message
        When I send "Boarding now" to ItineraryGroupID 10
        Then a Message exists with (UserID: 1, ItineraryGroupID: 10, Text: "Boarding now")

    Scenario: Block empty message
        When I send "" to ItineraryGroupID 10
        Then no new Message is created

@edit
Rule: Editting
    Scenario: Cannot edit another user's message
        When I click on MessageID 101
        Then I don't see "Edit"

    Scenario: Can edit my own message
        When I click on MessageID 103
        Then I see "Edit"

    Scenario: Edit my own message
        When I edit MessageID 103 to "Running 5 minutes late"
        Then MessageID 103 has Text "Running 5 minutes late"
    
    Scenario: Edit another user's message
        When I edit MessageID 101 to "Running 5 minutes late"
        Then MessageID 101 has Text "Landing at 5pm"

    Scenario: Edited messages display an "edited" indicator
        Given MessageID 103 was edited
        Then MessageID 103 shows an edited indicator

@send_failure
Rule: Send_failure
    Scenario: Failure to send a message doesn't create the message
        When I attempt to send "Boarding now" to ItineraryGroupID 10 and the request fails
        Then no new Message exists with (UserID: 1, ItineraryGroupID: 10, Text: "Boarding now")

    Scenario: Failure to send a message shows an error
        When I attempt to send "Boarding now" to ItineraryGroupID 10 and the request fails
        Then an error is shown for the failed send

    Scenario: Failure to send but the message persists
        When I attempt to send "Boarding now" to ItineraryGroupID 10 and the request fails
        Then I see "Boarding now"

@message_details
Rule: Message_details
    Scenario: View specific messages with sender 
        Then MessageID 101 shows UserID 2 

    Scenario: View specific messages with time
        Then MessageID 101 shows its send time

    Scenario: Can access the details option
        When I click on MessageID 103
        Then I see "Details"

    Scenario: Can view recepient status message
        Given MessageID 103 has been read only by UserID 2
        When I click on MessageID 103
        And I click "Details"
        Then I should see UserID 2 as read
        And I should see UserID 3 as unread

@chronological_order
Scenario: Chronological order of messages
    Then MessageIDs are ordered oldest-to-newest
