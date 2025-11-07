Feature:
    As an organizer
    I want to create a new itinerary specifying name, description, location, time frame, and cost       
    So that other users will be able to join and or view itinerary details

    # Happy Path
    @core
    Scenario: Successfully creating an itinerary
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Korea Trip!      |
            | description | Hitting up Seoul |
            | location    | Korea            |
            | start_date  | 2026-01-15       |
            | end_date    | 2026-01-29       |
            | is_private  | Public           |
            | cost        | 3500             |
        And I press "Create"
        Then I should see the success message "Itinerary Created"
        Then I should be on the home page
        And I should see "Korea Trip!"

    # Sad Paths
    @core
    Scenario: Missing 'location' field
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Europe Tour 2026   |
            | description | With the boys!     |
            | start_date  | 2026-05-11         |
            | end_date    | 2026-06-03         |
            | is_private  | Private            |
            | cost        | 5250               |
        And I press "Create"
        Then I should see the error message "location field can not be blank"

    @core
    Scenario: End date occurs before Start date
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Europe Tour 2026   |
            | description | With the boys!     |
            | location    | Spain & Italy      |
            | start_date  | 2026-05-11         |
            | end_date    | 2026-05-10         |
            | trip_type   | Private            |
            | cost        | 5250               |
        And I press "Create"
        Then I should see the error message "end_date must be after or the same as start_date"

    @core
    Scenario: Start date and or End date occuring in the past
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Europe Tour 2026   |
            | description | With the boys!     |
            | location    | Spain & Italy      |
            | start_date  | 2024-01-13         |
            | end_date    | 2024-02-10         |
            | trip_type   | Private            |
            | cost        | 5250               |
        And I press "Create"
        Then I should see the error message "start_date and end_date must be in the future"

    @core
    Scenario: Invalid input for 'cost'
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Europe Tour 2026   |
            | description | With the boys!     |
            | location    | Spain & Italy      |
            | end_date    | 2026-06-03         |
            | trip_type   | Private            |
            | cost        | <wrong_input>      |
        And I press "Create"
        Then I should see the error message <err_message>

        Examples:
            | wrong_input | err_message                        |
            | -100        | cost must be greater or equal to 0 |
            | one hundred | cost is not a number               |
            | 2537.56     | cost must be an integer            |

    @core
    Scenario: Invalid input for trip type
        Given I am a signed-in user
        And I am on the new itinerary page
        When I fill in the following:
            | title       | Europe Tour 2026   |
            | description | With the boys!     |
            | location    | Spain & Italy      |
            | start_date  | 2026-05-11         |
            | end_date    | 2026-05-10         |
            | trip_type   | Everyone           |
            | cost        | 5250               |
        And I press "Create"
        Then I should see the error message "trip_type must either be Public or Private"

    @core @auth
    Scenario: Unauthenticated user trying to create a new itinerary
        Given I am not signed in
        When I try to visit the new itinerary page
        Then I should be on the sign in page
        And I should see "Users must sign in or create an account to proceed."

