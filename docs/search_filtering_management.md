# Search Filtering Management 

## Overview
The **Search & Filtering Management System** enables users to search for itineraries using keywords and multiple filters (dates, party size, location, name, etc.)

Users are able to:
- Search itineraries by Title or Description
- Filter by date, party size, cost and location
- Distinguish between public itineraries and private itineraries

This allows for trip discovery to be fast and flexible

## User Story 1: Search and Filter Itineraries
As a user, I want to search and filter itineraries by keyword, date, party size, location, cost, and trip type so that I can quickly find trips that match my preferences.

## Acceptance Criteria 1
- If I type a word or phrase into the search box and hit “Search,” the page should only show itineraries that contain that word in the title or description.
- When I use any filters (date, party size, location, cost or trip type), the results should only include itineraries that match those filters.
- When I use more than one filter together, the results should match all selected filters.
- If no itineraries match my filters, I should see a message saying “No itineraries found.”
- If I click “Clear Filters,” all filters and the search box should reset, and all itineraries should reappear.

## User Story 2: View Itinerary Details
As a user, I want to view the full details of an itinerary so that I can decide whether I want to join that trip.

## Acceptance Criteria 2
- Each itinerary in the search results should display a summary (title, destination, date range, cost and party size).
- If I click on an itinerary, I should see its full details, including description, dates, locations, cost and group size..
- If any data is missing (like a description or location), I should see a placeholder or “Not available” message instead of a blank field.
- I should be able to return to the search results easily after viewing a trip’s details.

## MVC Outline
### Model
- Itinerary model to store data for each trip
    - Attributes:
        - `title:string`
        - `description:text`
        - `location:string`
        - `start_date:date` and `end_date:date`
        - `party_size:integer`
        - `trip_type:string`
        - `cost:string`
    - Methods
        - `search_by_keyword`, `filter_by_date_range`, `filter_by_party_size`, `filter_by_location`, `filter_by_trip_type`, `filter_by_cost`
### View
- `itineraries/index.html.erb`
    - A search bar and filter form with date range, min/max party size, location, trip type, and min/max cost
    - Displays a list of matching itineraries
    - Shows "no itineraries found" when filters return no results
    - A "submit" button to submit form and a "clear filters" button
- `itineraries/show.html.erb`
    - Displays full details for a selected itinerary when clicked on
    - Includes a "Back to results" button to return to the main list
### Controller
- ItinerariesController
    - `index` action - Handles the business logic
        - Reads query parameters and calls corresponding model scope to filter resultfs.
        - Renders the `index` view with matching itineraries.
    - `show` action - Displays a single itinerary
        - Finds itinerary by `id`.
        - Renders the `show` view