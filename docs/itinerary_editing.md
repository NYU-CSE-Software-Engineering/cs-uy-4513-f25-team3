# Itinerary Editing


## Overview
The **Itinerary Editing** feature allows users to update their existing itinerary.


Users are able to:
- Update the description
- Update the location
- Edit the Start and End Date
- Update trip type (Public or Private)
- Update trip cost


This will allow users to update their itinerary with any changes, without having to create a new one.


## User Story: Updating Itinerary
As a user<br>
I want to edit the description, location, start date, end date, trip type, and/or trip cost<br>
So that the itinerary can stay updated with any recent changes


## Acceptance Criteria
- When I open the itinerary settings, I should see editable fields for Description, Location, Start Date, End Date, Trip Type and Trip Cost
- It should show current values for all settings
- When I change the information it should update the itinerary
- If edited information is invalid, shows an error.


## MVC Outline — Itinerary Editing


### Model


**Itinerary model** to store information for each trip




- **Attributes**:
    - `title:string`
    - `description:text`
    - `location:string`
    - `start_date:date`
    - `end_date:date`
    - `trip_type:string`
    - `cost:integer`
    - `organizerID:integer`


- **Methods**:
    - `update_itinerary` - updates description, location, start date, end date, trip type, and/or trip cost.


### View
- **itineraries/edit.html.erb**  
    - Form fields for `title`, `description`, `location`, `start_date`, `end_date`, `trip_type`, `cost`
    - **Save Changes** button
    - Display input errors


- **itineraries/show.html.erb**  
    - Displays title, description, location, start date, end date, trip type, cost
    - Changes appear to all users after valid save
   


### Controller
- ItinerariesController
    - `edit` action - Loads current itinerary information into a form
    - `update` action - Handles Update
        - Validates Input
        - Updates Attributes
        - Redirects to itineraries/show with success message
        - Rerenders form with errors highlighted if error