Feature: Manage Hotels
    As a user
    I want to view and search hotels
    So that I can view details and filter hotels

    Background:
        Given the following hotels exist:
            | name           | location  | rating | arrival_time        | departure_time      | cost |
            | Hilton Times   | New York  | 3      | 2025-12-04 09:00:00 | 2025-12-12 13:00:00 | 300  |
            | Miami Resort   | Miami     | 4      | 2025-12-05 10:00:00 | 2025-12-09 14:00:00 | 325  |
        And I am on the hotels page

        Scenario: View all hotels
            Then I should see "Hilton Times"
            And I should see "Miami Resort"

        Scenario: Search hotels by location
            When I search for hotels in "New York"
            Then I should see "Hilton Times"
            And I should not see "Miami Resort"

        Scenario: Filter hotels by cost
            When I filter hotels with cost between 200 and 320
            Then I should see "Hilton Times"
            And I should not see "Miami Resort"
        
        Scenario: Filter hotels by rating
            When I filter hotels with a minimum rating of "4"
            Then I should see "Miami Resort"
            And I should not see "Hilton Times"

        # SAD PATHS
        Scenario: No hotels match filters
            When I search for hotels in "Mars"
            Then I should see a message "No hotels found"

        Scenario: Invalid cost input
            When I filter hotels with an invalid cost range
            Then I should see an error "Please enter valid numbers for cost"

        Scenario: End date before start date
            When I filter by dates between "2025-12-08" and "2025-12-01"
            Then I should see an error "End date must be after start date"