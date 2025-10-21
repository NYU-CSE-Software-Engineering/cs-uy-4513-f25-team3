Feature: Search and Filter Itineraries
    As a user
    I want to search and filter itineraries by keyword, date, location, cost, and trip type 
    So that I can quickly find trips that match my preferences.

Background: 

    Given the following itineraries exist:
    | title             | description                       | location    | start_date  | end_date    | trip_type | cost |
    | Hawaii Trip       | Fun week in Hawaii                | Honolulu    | 2025-12-01  | 2025-12-07  | Public    | 1200 |
    | Hawaii Private    | Private luxury Hawaii getaway     | Honolulu    | 2025-12-05  | 2025-12-10  | Private   | 3000 |
    | Ski Escape        | Skiing adventure in Aspen         | Aspen       | 2025-11-15  | 2025-11-20  | Public    | 800  |
    | Beach Relax       | Relaxing on Miami beaches         | Miami       | 2025-12-05  | 2025-12-10  | Public    | 1500 |
    | City Tour         | Explore New York City             | New York    | 2025-12-10  | 2025-12-12  | Public    | 500  |
    | Luxury Escape     | High-end resort experience        | Maldives    | 2025-12-15  | 2025-12-22  | Private   | 5000 |
    | Solo Adventure    | Solo hiking trip                  | Colorado    | 2025-11-20  | 2025-11-25  | Public    | 300  |
    And I am on the itineraries page

# HAPPY PATHS

Scenario: Search by keyword
    When I enter "Hawaii" in the search box and click "Search"
    Then I should see "Hawaii Trip"
    And I should see "Hawaii Private"
    And I should not see "Ski Escape"

Scenario: Filter itineraries by date range
    When I select a start date of "2025-12-05" and an end date of "2025-12-10"
    And I click "Search"
    Then I should see "Hawaii Trip"
    And I should see "Beach Relax"
    And I should not see "Solo Adventure"

Scenario: Filter itineraries by location
    When I choose "Aspen" from the location filter
    And I click "Search"
    Then I should see "Ski Escape"
    And I should not see "Hawaii Trip"

Scenario: Filter itineraries by trip type
    When I choose "Private" from the trip type filter
    And I click "Search"
    Then I should see "Hawaii Private"
    And I should see "Luxury Escape"
    And I should not see "City Tour"

Scenario: Filter itineraries by cost range
    When I enter a minimum cost of 700 and a maximum cost of 1500
    And I click "Search"
    Then I should see "Hawaii Trip"
    And I should see "Ski Escape"
    And I should see "Beach Relax"
    And I should not see "Hawaii Private"

Scenario: Combine multiple filters
    When I enter "Hawaii" in the search box
    And I choose "Public" from the trip type filter
    And I select a start date of "2025-12-01" and an end date of "2025-12-10"
    And I click "Search"
    Then I should see "Hawaii Trip"
    And I should not see "Hawaii Private"

Scenario: Clear all filters
    Given I have searched for "Hawaii"
    And I have selected "Private" from the trip type filter
    When I click "Clear filters"
    Then I should see all itineraries

# SAD PATHS

Scenario: No itineraries match filters
    When I enter "Antarctica" in the search box and click "Search"
    Then I should see a message that says "No itineraries found"

Scenario: Invalid input for filters
    When I enter a minimum cost of "abc" and click "Search"
    Then I should see an error message that says "Please enter valid numbers for cost"

Scenario: End date is before start date
    When I select a start date of "2025-12-10" and an end date of "2025-12-01"
    And I click "Search"
    Then I should see an error message that says "End date must be after start date"

Scenario: Filters are not applied until search is triggered
    When I enter "Hawaii" in the search box but do not click "Search"
    Then I should still see all itineraries