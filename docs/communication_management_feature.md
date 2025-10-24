# Communication Managment

## Overview
The **Communication & Notification Management System** allows users to communicate via a group chat and notifies them of new messages in the itinerary groups they are a part of

Users are able to:
- Access a chat for each group
- Send messges to a chat
- See senders and timestamp for each message
- Edit their own message

These are very basic capabilites all users will expect

## User Story: Group Chat
As a member of an itinerary group
I want to view, send, and edit messages with clear relevant details
So that I can communicate effectively with my group

## Acceptance Criteria
- If you open a group chat to you will see recent messages with sender name and timestamp.

-  If you are viewing a group chat all messages should display in chronological order 

-  If I send a non-empty message they appear immediately in the thread.

- If you want you can edit your own(and only your own) messages - “edited” indicator is displayed.

- If send fails show an error and allow a user an option to resend


## MVC Outline — Communication Management
### Model
- Message model to store chat messages and associate them with an itinerary group
  - Attributes:
    - `message_id:integer`
    - `user_id:integer`
    - `itinerary_group_id:integer`
    - `text:text`
    - `time:datetime`
    - `edited:boolean`
  - Methods:
    - `editable_by?(user)`

### View
- `messages/index.html.erb`
    - Displays a scrolable log of all messages
    - Has an entry field for user to type a message
    - Each message shows a small menu upon inspection with 
        - an edit option
        - and info option which fetches who have received and read it from some `notification/route...`

- `messages/show.html.erb`
    - Displays a table of recepients statuses for a message

### Controller
- MessagesController
    - `index` action - Shows a user latest messages from a group
        - Reads the group_id and checks if user is logged in, and part of the group
        - Renders the `index` template with the chat widget
    - `show` action - Used to provide details about a message
        - Retrives message details using `id`
        - Displays who has received and read the message which depends on the Notification Managment
    - `create` action - Happens when a user sends a message
        - Receives a text as json payload
        - Creates a new message entry
        - If fails it flashes to `index` persisting the message
        - Redirects to `index`
    - `edit` action - Allow the user to change content of a message they sent
        - Receives a text as json payload, and a `message_id` 
        - Validates if user is the author of the message
        - Updates the `Message` entry
        - Redirects to `index`
