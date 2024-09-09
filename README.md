# FoodFusion

Welcome to **FoodFusion**, a full-stack Ruby on Rails app. With FoodFusion, users can easily browse menus, place orders, and track their orders in real-time, all from a single platform.

## Table of Contents

1. [Key Features](#key-features)
2. [User Flows](#user-flows)
3. [Installation](#installation)
4. [Running the Application](#running-the-application)
5. [Testing](#testing)
6. [API Rate Limiting and Throttling](#api-rate-limiting-and-throttling)
7. [Screenshots](#screenshots)
8. [Mobile experience](#mobile-experience)
9. [Walkthrough: Building FoodFusion](#walkthrough-building-foodfusion)
10. [Contributing](#contributing)

## Key Features

- **User Authentication**: Secure login and signup functionalities.
- **Restaurant Discovery**: Browse a variety of restaurants with detailed menus.
- **Order Management**: Place and manage orders with real-time updates.
- **User Dashboards**: Separate dashboards for visitors and restaurant owners.
- **Notification System**: Real-time email notifications for order status updates.
- **Background Job Handling**: Efficient task management using Solidqueue.
- **Internationalization (I18n)**: Available in English and Hindi.
- **RESTful API**: Robust API with rate limiting, versioning, and security measures.
- **Dynamic Front-end**: Enhanced user interface with Hotwire (Turbo and Stimulus).
- **Mobile Experience**: Turbo Native integration for a native app-like experience on Android.

## User Flows

### Homepage

- **Login/SignUp**: Users can authenticate through the Login/SignUp button.
- **Restaurant List**: Browse all available restaurants.
- **Search Bar**: Quickly find specific restaurants.

### Restaurant Page

- **Menu View**: Explore the complete menu of each restaurant.
- **Order Modification**: Adjust the quantity of order items.
- **Order Placement**: Place orders directly from the menu.

### Order Confirmation Page

- Displays detailed information about the order, including items ordered, quantities, total cost and buttons to update order status.

### User Dashboards

#### Visitor Dashboard

- **Order History**: View a list of past orders.
- **Active Orders**: Track current orders with live status updates.
- **Account Settings**: Manage personal details and preferences.

#### Restaurant Owner Dashboard

- **Active Orders Overview**: Monitor and manage incoming orders.
- **Order Management System**: Accept, prepare, and mark orders as ready for delivery.
- **Menu Management**: Full CRUD functionality for menu items.
- **Basic Analytics**: View daily orders, popular items, and other key metrics.

### Notification System

- **Email Notifications**: Receive real-time updates on order status changes via email.

## Installation

To set up the application locally, follow these steps:

1. **Clone the Repository**:

    ```bash
    git clone https://github.com/bhavyansh001/foodfusion.git
    cd foodfusion
    ```

2. **Install Dependencies**:

    ```bash
    bundle install
    ```

3. **Setup the Database** (including seed data):

    ```bash
    rails db:setup
    ```

4. **Generate API Tokens for Users**:

    ```bash
    rails users:generate_api_tokens
    ```

## Running the Application

To run the application, use the following command:

```bash
bin/dev
```
## Testing

FoodFusion is well-tested using RSpec. The current test suite covers over 93% of the codebase, ensuring high reliability and robustness.

To run the tests, use the following command:

```bash
rspec
```

## API Rate Limiting and Throttling

To test API throttling, ensure that caching is enabled in the development environment. Enable caching by running:

```bash
rails dev:cache
``` 

## Screenshots

### Homepage

![Homepage](/screenshots/homepage.png)

----------

### Menu

![Menu](/screenshots/menu.png)

----------

### Visitor dashboard

![Visitor Dashboard](/screenshots/visitor_dashboard.png)

----------

### GET /restaurants

![GET /restaurants](/screenshots/api_get_restaurants.png)

----------

### POST /add_order

![POST /add_order](/screenshots/api_post_add_order.png)

## Mobile experience

Our Android app, built with Turbo Native, offers a native app-like experience, allowing you to browse menus, place orders, and track your order status with ease. Download the app now and enjoy the full FoodFusion experience on your mobile device:

[Download foodfusion APK](https://github.com/bhavyansh001/foodfusion/raw/main/android-app/foodfusion.apk)

## Walkthrough: Building FoodFusion
For a detailed account of how I built the FoodFusion app, including technical decisions, milestones, and the overall thought process, check out my blog post: [Building the FoodFusion Rails App — Ruby Deep Dive [24]](https://medium.com/@diversepixel/building-the-foodfusion-rails-app-ruby-deep-dive-24-9cb0703c20d6).

## Contributing

We welcome contributions to enhance FoodFusion. To contribute:

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature`).
3.  Make your changes and commit them (`git commit -m 'feat: Add new feature'`).
4.  Push the branch (`git push origin feature/YourFeature`).
5.  Create a new Pull Request.