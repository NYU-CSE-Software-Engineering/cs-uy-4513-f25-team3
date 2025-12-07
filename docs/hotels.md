# Searching and Filtering Hotels

## Overview
The **Hotels Management System** enables users to search for hotels using multiple filters (location, dates, cost, rating).

Users are able to:
- Search and filter hotels by location, departure/arrival date, rating and cost.
This allows for hotel discovery to be fast and flexible

## User Story: Search and Filter Hotels
As a user, I want to search and filter hotels by location, rating, arrival date, departure date, and cost so that I can quickly find hotels that match my preferences.

## Acceptance Criteria
- When I use any filters (date, location, rating or cost) and click search, the results should only include hotels that match those filters.
- If I click “Clear,” all filters and the search box should reset, and all hotels should reappear.

## MVC Outline
### Model
- Hotel model to store data for each hotel
    - Attributes:
        - `location:string`
        - `rating:float`
        - `departure_date:date` and `arrival_date:date`
        - `cost:integer`

### View
- `hotels/index.html.erb`
    - A search bar and filter form with date range, locations, and min/max cost
    - Displays a list of matching hotels
    - Shows "no hotels found" when filters return no results
    - A "Search" button to submit form and a "Clear" button

### Controller
- HotelsController
    - `index` action - Handles the business logic
        - Reads query parameters and calls corresponding model scope to filter results.
        - Renders the `index` view with matching hotels.