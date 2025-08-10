# Ticket Management System (TMS)

A comprehensive Django-based Ticket Management System that allows users to create and track support tickets while providing an interface for support agents and administrators to manage and resolve these tickets. The system features a modern, responsive UI with animations and a consistent design language across all pages.

## Features

- **User Authentication & Registration**
  - User self-registration and login with modern UI
  - Admin and support agent account management
  - Role-based access control with customizable permissions
  - Secure password management and reset functionality

- **Role-Based Dashboards**
  - User dashboard for ticket creation and tracking
  - Support agent dashboard for assigned tickets
  - Admin dashboard with comprehensive system oversight

- **Ticket Management**
  - Create, update, and track tickets with file attachments
  - Ticket categorization and priority settings
  - Internal notes for support staff
  - Ticket history and audit trail

- **Knowledge Base / FAQ System**
  - Categorized FAQ articles with search functionality
  - Category filtering for easy navigation
  - Admin interface for managing FAQ content
  - Integration with ticket system for quick references

- **Modern UI/UX**
  - Responsive design for all devices
  - Animated components for enhanced user experience
  - Consistent styling across all pages
  - Accessible interface with intuitive navigation

- **Support Features**
  - Contact form with multiple support channels
  - Interactive maps for physical locations
  - About page with team information and company details
  - Comprehensive user documentation

## Technology Stack

- **Backend**: Django 4.2+
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Database**: SQLite (development) / PostgreSQL (production-ready)
- **Authentication**: Django built-in auth with custom extensions
- **File Storage**: Django FileField with customizable storage backends

## Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/tms.git
   cd tms
   ```

2. Create and activate a virtual environment
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies
   ```
   pip install -r requirements.txt
   ```

4. Run migrations
   ```
   python manage.py migrate
   ```

5. Create initial roles and superuser
   ```
   python create_roles.py
   python create_superuser.py
   ```

6. Run the development server
   ```
   python manage.py runserver
   ```

7. Access the application at http://127.0.0.1:8000

## Recent Enhancements

- Modern UI redesign for FAQ, About, and Contact pages
- Improved FAQ filtering and categorization
- Enhanced user registration with proper role assignment
- Responsive navbar with improved mobile experience
- Animated components for better user engagement

## License

This project is licensed under the MIT License - see the LICENSE file for details.

