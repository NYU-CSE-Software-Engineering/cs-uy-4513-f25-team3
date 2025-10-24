# Itinerary Creation

## Overview
The **Create Itinerary** feature allows organizers to successfully generate itineraries that are viewable by all users.

Organizers are able to:
- Create a group name 
- Create an itinerary description
- Select a location
- Select a start and end date
- Name a trip cost
- Select trip type (Public or Private)


## User Story: Creating an Itinerary
As an organizer      
I want to create a new itinerary specifying name, description, location, time frame, and cost       
So that other users will be able to join and or view details

## Acceptance Criteria
- I should be able to enter a **name, description, location, start / end date, cost,** and **trip type** details on a form.
- A success message should appear when the itinerary is successfully created.
- An error message should appear, highlighting any missing / incorrect fields, preventing itinerary creation if such.
- I should be able to view details of a succesfully created itinerary on the dashboard / confirmation page.


## MVC Outline — Itinerary Creation

### Model
**Itinerary model** storing itinerary details

**Attributes:** 
- `title:string`
- `description:text`
- `location:string` 
- `start_date:date`
- `end_date:date`
- `trip_type:string` ('Public' or 'Private')
- `cost:integer`
- `organizerID:integer` (reference to organizer)

**Method:**
- `create_itinerary()` - creates an itinerary based on the listed attributes above

### View
**itineraries/create.html.erb**  
- Form fields for `title`, `description`, `location`, `start_date`, `end_date`, `trip_type`, `cost`
- “Create” button
- Displays respective success / error messages based on input

**itineraries/show.html.erb**  
- Displays title, description, location, start/end dates, trip type, cost
- Details available to all users after successful creation

### Controller
**ItinerariesController**
- `new` — renders a blank form for a new itinerary 
- `create` — validates field inputs --> saves itinerary --> redirects to 'organizers/home'