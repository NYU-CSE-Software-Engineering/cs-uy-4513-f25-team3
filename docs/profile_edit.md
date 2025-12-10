# Profile Editing

## Overview
The **Profile Editing** feature allows users to update their existing account information.

Users are able to:
- Change their first and last name
- Change their username
- Change their password
- Update personal details such as age and gender

## User Story: Profile Customization
As a registered user  
I want to change my first name, last name, username, password, age, or gender  
So that my profile information stays accurate and personalized

## Acceptance Criteria
- When I open my profile settings, I should see editable fields for **first name, last name, username, password, age, and gender**.
- When I modify public information (such as first name, last name, username, age, gender), it should become visible on my public profile.
- If I change my **username or password** old login credentials should no longer work.
- The system should not allow duplicate usernames.

## MVC Outline — Profile Editing

### Model
**User model** storing user account information.

**Attributes:**
- `FirstName:string`
- `LastName:string`
- `Username:string` 
- `Password:string`
- `Role:string`
- `Age:integer`
- `Gender:string`

**Methods:**
- `update_profile` — updates first name, last name, username, age, gender.
- `update_credentials` — securely updates and hashes password.

### View
**users/edit.html.erb**  
- Form fields for `FirstName`, `LastName`, `Username`, `Password`, `Age`, and `Gender`
- “Save Changes” button
- Display validation errors

**users/show.html.erb**  
- Displays first name, last name, username, age, gender
- Changes reflect immediately after update

### Controller
**UsersController**
- `edit` — Loads current user data into form  
- `update` — Handles submission  
  - Validates input
  - Updates allowed attributes
  - Re-renders form with errors if invalid
  - Redirects to `users/show` with success message
