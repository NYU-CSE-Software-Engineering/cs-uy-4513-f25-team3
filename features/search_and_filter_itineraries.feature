Feature: Search and Filter Itineraries
    As a user
    I want to search, filter, and view itineraries by keyword, date, location, cost, and trip type
    So that I can quickly find trips that match my preferences

Background:
    Given the following itineraries exist:
      | title           | description                | location  | start_date  | end_date    | is_private| cost |
      | Hawaii Trip     | Fun week in Hawaii         | Honolulu  | 2025-12-01  | 2025-12-07  | Public    | 1200 |
      | Hawaii Private  | Private luxury getaway     | Honolulu  | 2025-12-05  | 2025-12-10  | Private   | 3000 |
      | Ski Escape      | Skiing adventure in Aspen  | Aspen     | 2025-11-15  | 2025-11-20  | Public    | 800  |
      | Beach Relax     | Relaxing on Miami beaches  | Miami     | 2025-12-05  | 2025-12-10  | Public    | 1500 |
      | City Tour       | Explore New York City      | New York  | 2025-12-10  | 2025-12-12  | Public    | 500  |
      | Luxury Escape   | High-end resort experience | Maldives  | 2025-12-15  | 2025-12-22  | Private   |      |
      | Solo Adventure  | Solo hiking trip           | Colorado  | 2025-11-20  | 2025-11-25  | Public    | 300  |
    And I am on the itineraries page

# HAPPY PATHS

Scenario: Search itineraries by keyword
    When I search for itineraries containing "Hawaii"
    Then I should see the following itineraries: "Hawaii Trip", "Hawaii Private"
    And I should not see the following itineraries: "Ski Escape", "Beach Relax", "City Tour", "Luxury Escape", "Solo Adventure"

Scenario: Filter itineraries by date range
    When I filter by dates between "2025-12-05" and "2025-12-10"
    Then I should see the following itineraries: "Hawaii Trip", "Beach Relax"
    And I should not see the following itineraries: "Hawaii Private", "Ski Escape", "City Tour", "Luxury Escape", "Solo Adventure"

Scenario: Filter itineraries by location
    When I filter by location "Aspen"
    Then I should see the following itineraries: "Ski Escape"
    And I should not see the following itineraries: "Hawaii Trip", "Hawaii Private", "Breach Relax", "City Tour", "Luxury Escape", "Solo Adventure"

Scenario: Filter itineraries by trip type
    When I filter by trip type "Private"
    Then I should see the following itineraries: "Hawaii Private", "Luxury Escape"
    And I should not see the following itineraries: "Hawaii Private", "Ski Escape", "City Tour", "beach Relax", "Solo Adventure"

Scenario: Filter itineraries by cost range
    When I filter itineraries with cost between 700 and 1500
    Then I should see the following itineraries: "Hawaii Trip", "Ski Escape", "Beach Relax"
    And I should not see the following itineraries: "Hawaii Private"

Scenario: Combine multiple filters
    When I search for itineraries containing "Hawaii"
    And I filter by trip type "Public"
    And I filter by dates between "2025-12-01" and "2025-12-10"
    Then I should see the following itineraries: "Hawaii Trip"

Scenario: Clear all filters
    When I search for itineraries containing "Hawaii"
    And I filter by trip type "Private"
    And I filter by dates between "2025-12-05" and "2025-12-10"
    And I clear all filters
    Then I should see all itineraries

Scenario: View details of a public itinerary
    When I view the itinerary "City Tour"
    Then I should see the following details for "City Tour"

Scenario: View details of another public itinerary
    When I view the itinerary "Solo Adventure"
    Then I should see the following details for "Solo Adventure"

Scenario: View itinerary with missing field
    When I view the itinerary "Luxury Escape"
    Then I should see the following details for "Luxury Escape"


# SAD PATHS

Scenario: No itineraries match filters
    When I search for itineraries containing "Antarctica"
    Then I should see a message "No itineraries found"

Scenario: Invalid cost input
    When I filter itineraries with an invalid cost range
    Then I should see an error "Please enter valid numbers for cost"

Scenario: End date before start date
    When I filter by dates between "2025-12-10" and "2025-12-01"
    Then I should see an error "End date must be after start date"

Scenario: Filters not applied until search triggered
    When I enter "Hawaii" in the search box
    Then I should see all itineraries

Scenario: Return to search results after viewing details
    When I view the itinerary "City Tour"
    And I click "Back to results"
    Then I can return to the itineraries page

Scenario: Return to search results after viewing details
    When I view the itinerary "City Tour"
    Then I can return to the itineraries page

Scenario: Attempt to view a private itinerary
    When I view the itinerary "Hawaii Private"
    Then I should see a message "This itinerary is private and cannot be viewed."
    And I can return to the itineraries page