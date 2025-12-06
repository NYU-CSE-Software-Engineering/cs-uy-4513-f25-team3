# Searching and Filtering Flights

## Overview
The **Flights Management System** enables users to search for flights using multiple filters (dates, cost, location).

Users are able to:
- Search and filter flights by departure/arrival location, departure/arrival date, and cost.
This allows for flight discovery to be fast and flexible

## User Story: Search and Filter Hotels
As a user, I want to search and filter flights by departure location, arrival location, departure date, arrival date, and cost so that I can quickly find flights that match my preferences.

## Acceptance Criteria
- When I use any filters (date, location, or cost) and click search, the results should only include flights that match those filters.
- If I click “Clear,” all filters and the search box should reset, and all flights should reappear.

## MVC Outline
### Model
- Flight model to store data for each flight
    - Attributes:
        - `depature_location:string`
        - `arrival_location:string`
        - `departure_date:date` and `arrival_date:date`
        - `cost:integer`

### View
- `flights/index.html.erb`
    - A search bar and filter form with date range, locations, and min/max cost
    - Displays a list of matching flights
    - Shows "no flights found" when filters return no results
    - A "Search" button to submit form and a "Clear" button

### Controller
- FlightsController
    - `index` action - Handles the business logic
        - Reads query parameters and calls corresponding model scope to filter results.
        - Renders the `index` view with matching flights.