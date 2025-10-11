# 🌍 WhereOnEarth App

A lightweight SwiftUI-based iOS app that helps users discover and manage country information using the https://restcountries.com/v3.1/all. The app supports iOS 18+ and is built with a focus on clean architecture, offline support, and reactive data handling.

✨ Features

🏠 Country Home View

Add Country Button:

Opens a sheet to search and select up to 5 countries to add to the “Selected Countries” list.

Default Country Detection:

Automatically detects the user's country via GPS.

If location permission is denied, defaults to Egypt.

Displays Default Country Info:

Flag

Name

Capital

Currency and symbol

When clicked on default country it will navigate to country Details

Selected Countries Section:

Shows selected countries with flag and name.

Allows removal via delete button and confirmation dialog.

Limits selection to 5 countries with toast notification if exceeded.


🔍 Country Selection

Add Country Sheet:


Supports multi-selection.

Caches selected countries for offline access.


📄 Country Details View

Displays comprehensive information about a selected country:

Flag

Name

Capital

Currency and symbol

Languages


🧱 Architecture

MVVM + Router Pattern


Model: Defines data structures (e.g., Country, CountryDTO).

View: UI components (e.g., HomeScreen, CountryDetailsScreen).

ViewModel: Handles business logic, prepares data, and interacts with use cases and managers.

Router: Manages navigation flow using NavigationManager.


🔁 Reactive Programming with Combine

Utilizes Apple’s Combine framework for managing asynchronous data and UI updates.

Enhances maintainability, readability, and testability by reducing boilerplate.


🗂 Use Cases & Repository & Mapper

Mapper: Defines map for models between layers (Domain and Data layers)

Use Cases: Encapsulate business logic and interact with the repository.

Repository: Bridges use cases and remote data source, ensuring data availability.


🌐 Networking & Data Layer
RemoteDataSource: Handles API calls via a custom networking layer.
Networking Layer: Manages request construction, response handling, and error reporting.
Local Storage: Uses UserDefaults to cache country data for offline access.

🧪 Testing
Includes unit tests for:

Network Layer
Repository
Use Cases
ViewModels
🧰 Technologies Used

Language: Swift 5.0+
UI Framework: SwiftUI
Networking: URLSession
Local Storage: UserDefaults
Image Loading: SDWebImageSwiftUI
Testing: XCTest
🎨 Design & Layout

Focused on functional, clean layout over visual aesthetics.
Reusable components for consistency and performance.
Displays error messages and empty states when API fails.
📶 Offline Support

Caches selected countries for offline access.
Alerts user when offline.
Swipe-to-refresh available when back online.
