Feature: View Itinerary
    As a user browsing itineraries
    I want to view the full details of a selected itinerary
    So that I can see the destination, cost, dates, and trip type

Background:
    Given the following itineraries exist:
    | title             | description                       | location    | start_date  | end_date    | trip_type | cost |
    | Hawaii Trip       | Fun week in Hawaii                | Honolulu    | 2025-12-01  | 2025-12-07  | Public    | 1200 |
    | Hawaii Private    | Private luxury Hawaii getaway     | Honolulu    | 2025-12-05  | 2025-12-10  | Private   | 3000 |
    | Ski Escape        | Skiing adventure in Aspen         | Aspen       | 2025-11-15  | 2025-11-20  | Public    | 800  |
    | Beach Relax       | Relaxing on Miami beaches         | Miami       | 2025-12-05  | 2025-12-10  | Public    | 1500 |
    | City Tour         | Explore New York City             | New York    | 2025-12-10  | 2025-12-12  | Public    | 500  |
    | Luxury Escape     | High-end resort experience        | Maldives    | 2025-12-15  | 2025-12-22  | Private   |      |
    | Solo Adventure    | Solo hiking trip                  | Colorado    | 2025-11-20  | 2025-11-25  | Public    | 300  |
    And I am on the itineraries page

# HAPPY PATHS

Scenario: View details of a public itinerary
    When I select the itinerary "City Tour"
    Then I should see the location "New York"
    And I should see the cost "500"
    And I should see the trip type "Public"
    And I should see the description "Explore New York City"

Scenario: View another public itinerary
    When I select the itinerary "Solo Adventure"
    Then I should see the location "Colorado"
    And I should see the cost "300"
    And I should see the description "Solo hiking trip"

Scenario: View itinerary with missing field
    When I click on "Luxury Escape"
    Then I should see the cost "Not available"

# SAD PATH

Scenario: Return to search results after viewing details
    Given I am viewing the itinerary "City Tour"
    When I click "Back to results"
    Then I should return to the same search results I came from
    And the page should not crash or show blank spaces

Scenario: Viewing a private itinerary
    Given I am on the itineraries page
    When I click on "Luxury Escape"
    Then I should see a message "This itinerary is private and cannot be viewed."
    And I should see a link to return to the itineraries list