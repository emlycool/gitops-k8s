# Ticket Management System - Models Documentation

This document provides detailed information about all database models in the Ticket Management System, including their attributes, relationships, and purpose.

## Table of Contents

1. [Role](#role)
2. [UserMeta](#usermeta)
3. [TicketCategory](#ticketcategory)
4. [Ticket](#ticket)
5. [TicketResponse](#ticketresponse)
6. [TicketAction](#ticketaction)
7. [FAQKnowledgeBase](#faqknowledgebase)
8. [Media](#media)

## Role

The `Role` model defines different user roles in the system and their associated permissions.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `name` | CharField | Name of the role (e.g., 'admin', 'support', 'user') |
| `permissions` | TextField | Comma-separated list of permissions for this role |
| `created_at` | DateTimeField | Timestamp when the role was created |
| `updated_at` | DateTimeField | Timestamp when the role was last updated |

### Available Permissions

- `view_all_tickets`: Can view all tickets in the system
- `edit_all_tickets`: Can edit all tickets in the system
- `assign_tickets`: Can assign tickets to support agents
- `view_assigned_tickets`: Can view tickets assigned to them
- `respond_to_tickets`: Can respond to tickets
- `close_tickets`: Can close tickets
- `manage_users`: Can manage user accounts
- `manage_categories`: Can manage ticket categories
- `manage_faq`: Can manage FAQ/Knowledge Base entries

### Methods

- `get_permissions()`: Returns a list of permissions for this role
- `has_permission(permission)`: Checks if the role has a specific permission
- `set_permissions(permissions_list)`: Sets permissions from a list
- `set_permission(permission_name, has_permission)`: Adds or removes a specific permission

## UserMeta

The `UserMeta` model extends the built-in Django User model with additional profile information.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `user` | OneToOneField | Foreign key to Django's User model |
| `first_name` | CharField | User's first name |
| `last_name` | CharField | User's last name |
| `full_name` | CharField | Automatically generated full name |
| `gender` | CharField | User's gender (choices: Male, Female, Other) |
| `contact_number` | CharField | User's contact phone number |
| `location` | CharField | User's location/address |
| `role` | ForeignKey | Foreign key to Role model |
| `is_profile_completed` | BooleanField | Indicates if the user has completed their profile |
| `created_at` | DateTimeField | Timestamp when the profile was created |
| `updated_at` | DateTimeField | Timestamp when the profile was last updated |

### Signal Handlers

- `create_user_meta`: Automatically creates a UserMeta instance when a new User is created, assigning the default 'user' role

## TicketCategory

The `TicketCategory` model defines categories for organizing tickets.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `name` | CharField | Name of the category |
| `description` | TextField | Description of the category |
| `created_at` | DateTimeField | Timestamp when the category was created |
| `updated_at` | DateTimeField | Timestamp when the category was last updated |

## Ticket

The `Ticket` model is the core model for support tickets in the system.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `user` | ForeignKey | User who created the ticket |
| `assigned_to` | ForeignKey | Support agent assigned to the ticket |
| `category` | ForeignKey | Category of the ticket |
| `title` | CharField | Title/subject of the ticket |
| `description` | TextField | Detailed description of the issue |
| `status` | CharField | Current status (pending, in_progress, resolved, closed) |
| `priority` | CharField | Priority level (low, medium, high, urgent) |
| `created_at` | DateTimeField | Timestamp when the ticket was created |
| `updated_at` | DateTimeField | Timestamp when the ticket was last updated |

### Properties

- `ticket_id`: Returns a formatted ticket ID (e.g., TKT-0001)

### Methods

- `get_absolute_url()`: Returns the URL for the ticket detail view

## TicketResponse

The `TicketResponse` model stores responses to tickets from both users and support staff.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `ticket` | ForeignKey | Ticket this response belongs to |
| `user` | ForeignKey | User who created the response |
| `message` | TextField | Content of the response |
| `created_at` | DateTimeField | Timestamp when the response was created |
| `updated_at` | DateTimeField | Timestamp when the response was last updated |

## TicketAction

The `TicketAction` model records internal actions taken on tickets by support staff.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `ticket` | ForeignKey | Ticket this action relates to |
| `performed_by` | ForeignKey | User who performed the action |
| `action_type` | CharField | Type of action (review, update, escalate, etc.) |
| `action_taken` | CharField | Brief description of the action |
| `resolution_summary` | TextField | Detailed summary of resolution if applicable |
| `notes` | TextField | Internal notes about the action |
| `created_at` | DateTimeField | Timestamp when the action was recorded |
| `updated_at` | DateTimeField | Timestamp when the action was last updated |

### Action Types

- `review`: Ticket was reviewed
- `update`: Ticket information was updated
- `escalate`: Ticket was escalated to higher support
- `assign`: Ticket was assigned/reassigned
- `status_change`: Ticket status was changed
- `note`: Internal note was added
- `reset_password`: User password was reset
- `other`: Other action not covered above

## FAQKnowledgeBase

The `FAQKnowledgeBase` model stores frequently asked questions and knowledge base articles.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `question` | CharField | The question or title of the FAQ item |
| `answer` | TextField | The answer or content of the FAQ item |
| `category` | CharField | Category of the FAQ (general, account, tickets, billing, technical) |
| `order` | PositiveIntegerField | Display order within category (lower numbers shown first) |
| `related_ticket_category` | ForeignKey | Related ticket category if applicable |
| `created_by` | ForeignKey | User who created the FAQ item |
| `is_published` | BooleanField | Whether the FAQ is published and visible to users |
| `created_at` | DateTimeField | Timestamp when the FAQ was created |
| `updated_at` | DateTimeField | Timestamp when the FAQ was last updated |

### Meta Options

- `ordering`: Items are ordered by category, then order, then question

## Media

The `Media` model handles file uploads attached to tickets.

### Attributes

| Field | Type | Description |
|-------|------|-------------|
| `ticket` | ForeignKey | Ticket this file is attached to (optional) |
| `user` | ForeignKey | User who uploaded the file |
| `file` | FileField | The uploaded file |
| `file_type` | CharField | MIME type or category of the file |
| `uploaded_at` | DateTimeField | Timestamp when the file was uploaded |

## Database Relationships

### User-Related Relationships

- Each User has one UserMeta profile (one-to-one)
- Users can create multiple Tickets (one-to-many)
- Support agents can be assigned multiple Tickets (one-to-many)
- Users can create multiple TicketResponses (one-to-many)
- Support staff can perform multiple TicketActions (one-to-many)
- Users can create multiple FAQKnowledgeBase items (one-to-many)
- Users can upload multiple Media files (one-to-many)

### Ticket-Related Relationships

- Each Ticket belongs to one User (many-to-one)
- Each Ticket can be assigned to one support agent (many-to-one)
- Each Ticket belongs to one TicketCategory (many-to-one)
- Tickets can have multiple TicketResponses (one-to-many)
- Tickets can have multiple TicketActions (one-to-many)
- Tickets can have multiple Media attachments (one-to-many)

### Other Relationships

- Each UserMeta is associated with one Role (many-to-one)
- Each FAQKnowledgeBase item can be related to one TicketCategory (many-to-one)

## Data Flow and Integrity

- When a User is created, a UserMeta is automatically created with the default 'user' role
- Tickets must have a valid TicketCategory (protected deletion)
- When a Ticket is deleted, all associated TicketResponses, TicketActions, and Media are also deleted (cascade deletion)
- When a User is deleted, all their Tickets, TicketResponses, TicketActions, FAQKnowledgeBase items, and Media are also deleted (cascade deletion)
- When a Role is deleted, associated UserMeta instances have their role set to NULL (SET_NULL)
