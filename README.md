# News Reader iOS App

## Overview

This application fetches and displays a list of news articles using the [NewsAPI](https://newsapi.org/). Users can browse articles by category, view article details, and bookmark articles for later reading. The app implements an offline-first approach using Core Data to store the last successfully fetched articles.

### Functional Features

- **Browse Articles**: Users can browse articles by categories. The categories are displayed as selectable chips allowing multiple selections.
- **Article Details**: Tap on an article to view its details, including the image, title, subtitle, and options to read more or bookmark.
- **Bookmarking**: Users can bookmark articles for later reading.
- **Offline Support**: The app caches articles using Core Data, allowing users to access the last fetched articles even when offline.
- **Filtering**: Users can filter news articles by category.

### Non-Functional Features

- **MVVM Architecture**: Implements the Model-View-ViewModel pattern for a clear separation of concerns.
- **Dependency Injection**: Uses DI to make the code modular and testable.
- **Async/Await**: Utilises async/await for asynchronous tasks.
- **Core Data**: Uses Core Data for persistent storage.
- **SwiftUI**: Employs SwiftUI for building a declarative, reusable, and responsive UI.
- **Error Handling**: Implements comprehensive error handling throughout the app.
- **Testing**: Includes unit tests to ensure app reliability.
- **Best Practices**: Follows SOLID principles, uses design patterns, and avoids force unwrapping and other bad practices.

### Testing Strategy

- **Unit Tests**: Tests for ViewModels and services to ensure proper business logic and error handling. Similarly coverage could be improved by writing unit test cases for other pieces of code.
- **UI Tests**: TODO
- **Error Handling Tests**: Ensures the app handles network errors, API errors, and decoding errors gracefully.

### Implementation Choices

- **NetworkService**: Designed to be generic and reusable, handling all network requests and error handling.
- **Core Data Manager**: Manages all interactions with Core Data, providing methods to save and fetch articles.
- **ViewModels**: Each view has a corresponding ViewModel that handles data fetching, error handling, and state management.
- **Views**: SwiftUI views are modular and reusable. Components like `SelectableChipsView` others can be reused. 
- **Async/Await**: Async/await is used for asynchronous network calls while observable objects are used to listen to state changes.

### Additional Notes

- **Error Messages**: Error messages are user-friendly and provide enough context for troubleshooting. For production based app its better show more abstract information to user. 
- **Offline Mode**: If the app cannot fetch articles from the API, it automatically loads articles from Core Data.
- **API Key Handling**: Currently Api key is stored in plist file, which could be encrypted at build time by writing script for security. 

### How to Run the App

1. Clone the repository.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a device.

### Dependencies
- **iOS 17.0+**: The app uses SwiftUI and async/await features available in iOS 17 and later.
- **Swift 5.10+**: (swiftlang-5.10.0.13 clang-1500.3.9.4)

## Screenshots

|App Icon| Headlines|Bookmarks Empty|Detail View|Detail View Bookmamrked|Bookmarks View with items|
|:-:|:-|:-|:-|:-|:-|
|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.27.26.png" width="200" height="300">|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.30.02.png" width="200" height="300">|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.30.13.png" width="200" height="300">|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.30.25.png" width="200" height="300">|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.30.29.png" width="200" height="300">|<img src="https://github.com/roshan061020/HeadLines/blob/main/ShortNews/Screenshots%20%26%20Videos/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-09-18%20at%2023.30.45.png" width="200" height="300">|


