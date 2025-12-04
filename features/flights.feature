Feature: Manage Flights
    As a user
    I want to view and search flights
    So that I can view details and filter flights

    Background:
        Given the following flights exist:
            | flight_number | departure_location | arrival_location | departure_time      | arrival_time        | cost |
            | IC067         | New York           | Austin           | 2025-12-04 09:00:00 | 2025-12-04 13:00:00 | 400  |
            | DL202         | Boston             | Miami            | 2025-12-05 10:00:00 | 2025-12-05 14:00:00 | 425  |
        And I am on the flights page

        Scenario: View all flights
            Then I should see "IC067"
            And I should see "DL202"

        Scenario: Search flights by departure location
            When I search for flights departing from "New York"
            Then I should see "IC067"
            And I should not see "DL202"

        Scenario: Search flights by arrival location
            When I search for flights arriving at "Miami"
            Then I should see "DL202"
            And I should not see "IC067"

        Scenario: Filter flights by cost
            When I filter flights with cost between 300 and 410
            Then I should see "IC067"
            And I should not see "DL202"
        
        # SAD PATHS
        Scenario: No flights match filters
            When I search for flights departing from "Antarctica"
            Then I should see a message "No flights found"

        Scenario: Invalid cost input
            When I filter flights with an invalid cost range
            Then I should see an error "Please enter valid numbers for cost"

        Scenario: End date before start date
            When I filter by dates between "2025-12-10" and "2025-12-01"
            Then I should see an error "End date must be after start date"