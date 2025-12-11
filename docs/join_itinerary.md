# Itinerary Joining

## Overview
The **Join Itinerary** feature allows signed-in users to become an attendee of an existing itinerary group.

Users are able to:
- Join public itineraries without restriction
- Join private itineraries by first entering the correct password

## User Story: Joining an Itinerary
As a signed-in user
I want to join a publicly accessible itinerary group
So that I can participate in the trip

As a signed-in user
I want to enter a password to join a private itinerary group
So that only authorized users can participate in the trip

## Acceptance Criteria
- When I join a public itinerary, I should be added as an attendee and see a confirmation message.

- When I join a private itinerary with the correct **password**, I should be added as an attendee and redirected with a success message.

- When I enter a wrong **password** for a private itinerary, I should see an error message and should not be added as an attendee.

- When I have already joined an itinerary, I should not be added again, and I should continue seeing a success/confirmation state without duplicates.

- When I attempt to access the join page while not logged in, I should be redirected to the login page with a “Please log in to continue” message.



## MVC Outline - Itinerary Joining
### Model
**ItineraryGroup**
- **Attributes**:
    - `id:integer` (group id)
    - `title:string`
    - `is_private:boolean`
    - `password:string`
    - `organizer_id:integer` (for ownership purposes)
- **Validations/Methods**:
    - `private_password_check()`

**ItineraryAttendee**
- **Attributes**:
    - `user_id:integer`
    - `itinerary_group_id:integer`
- **Validations/Methods**:
    - `duplicate_join_check()`

**Users**
- **Attributes**:
    - `id:integer` (user id)
- **Validations/Methods**:
    - `current_user.itinerary_groups`  (check with itinerary groups user is part of)


### View
**show.html.erb**
- Displays itinerary details only if itinerary is public or user has already joined / is the organizer
- Hides itinerary details for private itineraries until user joins
- Join Trip button

**join.html.erb**
- Password entry form for private itineraries
- Join trip button
- On submit → POST to join_itinerary_path

### Controller
**ItinerariesController**
- `show`- if private, show password form and join button, if public, show details and join button
- `join` - renders(GET) password form for private itineraries
- `join_itinerary` - validates(POST) password, adds user to itinerary attendees, redirect to itinerary page after success

**SessionsController**
- `create` - signs user in
- `destroy` - signs user out

