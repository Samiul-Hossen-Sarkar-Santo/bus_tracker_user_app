# Bus Tracker User App

## Overview

The Bus Tracker User App is a mobile application built using Flutter that helps users track bus routes and stops in real-time. The app provides a simple and interactive interface to view and search for bus routes, get detailed information about routes and their stops, and navigate to route details with zoomable images.

## Features

- **Home Screen:**
  - Search bar for quick access to routes or stops.
  - Grid layout displaying available bus routes.
  - Routes are shown in cards with the route title, and users can tap a card to navigate to the route's detailed page.

- **Search Functionality:**
  - Real-time search filtering for routes and stops based on the search query.
  - Ability to search by route title or stoppage name.
  - Results are displayed dynamically, removing non-matching routes from the grid.

- **Route Details Page:**
  - Detailed view of a selected route, including an interactive image viewer to zoom in and out of route images.
  - If no image is available, a placeholder text is displayed.

- **Navigation:**
  - Easy navigation between screens with the ability to return to the home screen.
  - Back button on the route details page customized to match the app's theme.

## Tech Stack

- **Flutter**: Framework for building the cross-platform app.
- **Dart**: Programming language used for development.
- **Material Design**: UI framework for building a consistent design.

## Setup

### Prerequisites
- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes with the Flutter SDK.
- A code editor like VS Code or Android Studio.

### Steps to Run

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd bus_tracker_user_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Features Implemented
- **Search functionality**: Search for routes and stops with real-time filtering.
- **Home screen layout**: Display bus routes as cards.
- **Interactive image viewer**: Zoomable route images on the details page.
- **Route details page**: Provides detailed route information.

## Future Improvements

- **Map Integration**: To display the real-time location of buses using the Google Maps API.
- **Push Notifications**: Alerts for bus arrivals or changes in routes.
- **User Accounts**: Add functionality for user authentication and personalized settings.

## Release Notes

### Version 1.0.0 (Latest Release)

- **Initial MVP release** with core features:
  - Search bar integrated into the home screen for easy searching of bus routes and stops.
  - Display bus routes as clickable cards on the home screen.
  - Route details page with interactive zoomable images.
  - Improved user experience with clean and visually appealing design.
  - Customization of back button color for consistent UI theme.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
```

---

### Explanation:

- **Overview**: A brief summary of the app's purpose and core functionality.
- **Features**: Describes the key features that are part of the app.
- **Tech Stack**: Lists the main technologies used to build the app.
- **Setup**: Provides instructions on how to set up and run the app on your local machine.
- **Release Notes**: Information about the current version of the app and what has been implemented so far.
- **Future Improvements**: A list of features and improvements that you plan to implement in the future.

This should give a clear and concise view of the project so far. When you’re ready to add a release for this version, you can follow the instructions to update the release notes.