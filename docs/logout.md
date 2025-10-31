# Logout Management

## Overview
The **logout feature** enables users to logout of their account This feature allows for privacy and ensures only a logged in user can access information.


## User Story: Logout
As a user/organizer that is logged in, I want to log out of my account so that no one else can access my information from this device.


## Acceptance Criteria
- A user is able to successfully logout.
- A user should not be able to logout without being logged in.
- A user should not be able to access certain pages after logging out.
- If a session expires, the user is automatically logged out and cannot be logged out.



## MVC Outline
### Model
- User Model
    - Attributes:
        - `user_id:string`
        - `username:string`
        - `password:string`
        - `first_name:string`
        - `last_name:string`
        - `age:integer`
        - `gender:string`
  
### View
Not necessary as this is a controller-driven redirect but a "Logout" button is available in the navigation bar.

### Controller
- SessionController
    - `delete` action - clears session, redirects, sets flash
   - `new` action - empty form
        - creates empty login