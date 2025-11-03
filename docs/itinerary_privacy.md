# Itinerary Privacy Management
## Overview

The Itinerary Privacy Management System allows organizers to control access to their trips by setting itineraries as **Public** or **Private** with an optional password. This ensures that only approved users can join private trips, while public trips remain open to all users.

Organizers can:
- Toggle between Public and Private trip types
- Assign or remove a password for private trips
- Restrict access so that only users who know the password can join

Users can:
- Attempt to join a private trip by entering the correct password
- Receive feedback if an incorrect password is entered
- Join public trips freely without authentication


## User Story: Itinerary Privacy and Password Protection

As an organizer, I want to make an itinerary private and password-protected so that only users I approve can join the trip.
As a user, I want to join a private trip by entering a valid password so that I can participate securely.

## Acceptance Criteria
- Organizers can toggle a trip’s trip_type between Public and Private via the itinerary settings page.
- When Private is selected, the organizer must be able to set a password.
- Upon saving, the itinerary should display “Private” and show a success message confirming the update.
- When a user attempts to join a private trip:
    - If the correct password is entered, the user is added to the trip and shown a confirmation message.
    - If the incorrect password is entered, the user remains on the join page with an “Incorrect trip password” message.
- Private itineraries require password authentication to join and public itineraries do not require a password and are visible to all users.


## MVC Outline
### Model
- Itinerary model
    - Attributes:
        - title:string
        - description:text
        - location:string
        - start_date:date
        - end_date:date
        - trip_type:string (Public or Private
        - password:string (stored securely using has_secure_password)
        - cost:integer
    - Validations:
        - Require password only when trip_type is Private
        - Ensure trip_type is either Public or Private
    - Methods:
        - private? → returns true if itinerary is private
        - authenticate(password) → verifies password for private itineraries
        - make_private(password) → sets trip_type to private and stores password
        - make_public → sets trip_type to public and clears password

### View
- itineraries/edit.html.erb
    - Dropdown for “Trip Type” selection
    - Password input field (visible only if Private selected)
    - “Save Changes” button to apply updates
- itineraries/show.html.erb
    - Displays current trip type (“Public” or “Private”)
    - Prevents join button for private trips unless password verified
- itineraries/join.html.erb
    - Input field for entering trip password
    - “Join Trip” button
    - Error message display for incorrect password attempts

### Controller

- ItinerariesController
    - update action:
        - Handles trip type and password changes from the settings form.
        - Saves itinerary and redirects to itinerary page with success message.
    - join action:
        - Verifies password for private itineraries.
        - Adds user to itinerary if password matches.- Renders error message if password is incorrect  
    - show action:
        - Displays itinerary details, ensuring privacy rules are enforced.