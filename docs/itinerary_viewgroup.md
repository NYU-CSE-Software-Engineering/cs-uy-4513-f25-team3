# View Group Users

## Overview
The **View Group Users** feature allows users to view the group attending an itinerary.

This will allow users to know the people they are going on a trip with.

## User Story: Viewing Group Members
As a user<br>
I want to view the group attending an itinerary<br>
So I can know the people I am going on a trip with

## Acceptance Criteria
- When I view an itinerary group page, I should see a list of everyone attending
- I should see the names of all attendees
- If the group is private and I'm not a member, I should not have access to the member list
- The member list should update when members change
- 

## MVC Outline – View Group Users

### Model

**User model** to store user information

- **Attributes**:
    - `first_name:string`
    - `last_name:string`
    - `username:string`
    - `password:string`
    - `role:string`
    - `age:integer`
    - `gender:string`

**ItineraryGroup model** to store information about each trip

- **Attributes**:
    - `title:string`
    - `description:string`
    - `start_date:date`
    - `end_date:date`
    - `is_private:boolean`
    - `organizer_id:integer`
    - `cost:float`
    - `password:string`
    - `location:string`

**ItineraryAttendee model** to track group membership

- **Attributes**:
    - `user_id:integer`
    - `itinerary_group_id:integer`

### View
- **itinerary_groups/show.html.erb**
    - Displays itinerary group details
    - Shows "Group Members" section
    - Lists all member names

### Controller
- ItineraryGroupsController
    - `show` action - Displays group details and member list
        - Loads the itinerary group
        - Loads all attendees
        - Checks access permissions for private groups