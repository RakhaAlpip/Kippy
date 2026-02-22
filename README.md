# Kippy - Photo & Meme Sharing App 🐸

Kippy is a vibrant, community-driven photo and meme sharing application built with Flutter. It allows users to login, register, scroll through a dynamic feed, explore content by genre, engage with posts through likes and comments, and manage their personal profiles. 

## 🚀 Features

*   **Authentication**: User login and registration using Firebase Authentication.
*   **Dynamic Feed**: Infinite scrolling home feed with immediate post updates.
*   **Explore & Search**: Discover new content filtered by genre or search queries.
*   **Interactions**: Like, save/bookmark, and comment on posts using a modern bottom-sheet UI.
*   **Profile Management**: View user posts, bookmarks, and edit profile details.
*   **Activity Notifications**: Stay updated with recent likes and follows.
*   **Custom UI/UX**: Clean "broken white" aesthetic with engaging full-screen image viewing and zoom capabilities.
*   **Swipe Navigation**: Seamless PageView and BottomNavigationBar navigation flow.

## 🏗 Architecture

This project strictly adheres to **Clean Architecture** principles to separate concerns, improve testability, and maintain scalability. The codebase is divided into three main layers:

1.  **Domain (Core Business Logic)**
    *   **Entities**: Independent core business objects (`User`, `Post`).
    *   **Use Cases**: Application-specific business rules (`Login`, `GetFeedPosts`).
    *   **Repositories (Abstract)**: Interfaces for data access.

2.  **Data (External Interfaces & Persistence)**
    *   **Models**: Data transfer objects (DTOs) that extend Entities (e.g., `UserModel` with `fromJson`).
    *   **Data Sources**: Interfaces for remote (API/Firebase) and local (Hive/SharedPreferences) data access.
    *   **Repositories (Implementation)**: Concrete implementations of Domain repository interfaces.

3.  **Presentation (UI & State Management)**
    *   **BLoC**: Business Logic Components bridging the UI and Use Cases.
    *   **Pages/Widgets**: Flutter UI components reacting to BLoC states.

## 🛠 Tech Stack & Libraries

*   **Framework**: [Flutter](https://flutter.dev/)
*   **State Management**: `flutter_bloc`, `equatable`
*   **Dependency Injection**: `get_it`
*   **Networking**: `dio`
*   **Local Storage**: `shared_preferences`, `hive`, `hive_flutter`
*   **Data Handling**: `dartz` (for functional error handling), `json_serializable`
*   **Backend Services**: Firebase Core, Auth, Storage, Cloud Firestore
*   **Assets & UI**: `cached_network_image`, `lottie`, `flutter_launcher_icons`

## 📂 Folder Structure

```
lib/
├── config/             # App routing and global configuration
├── core/               # Shared utilities, theme, networking clients, injection container
│   ├── errors/         # Failures and Exceptions definitions
│   ├── network/        # Base Dio client setups
│   └── theme/          # App theme definitions
├── features/           # App features isolated by domain
│   ├── auth/           # Login, Register functionalities
│   ├── explore/        # Search and discover UI and logic
│   ├── home/           # Main feed and post functionalities
│   ├── profile/        # User profile, settings, and edit functionalities
│   └── social/         # Comments, likes, and activity notifications
└── main.dart           # App entry point
```

## ⚙️ Getting Started

### Prerequisites
*   Flutter SDK (>=3.9.0)
*   Dart SDK
*   An active Firebase project with Authentication, Firestore, and Storage enabled.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yourusername/kippy.git
    cd kippy
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate files (if needed):**
    For JSON serialization and other code generation:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```bash
    flutter run
    ```

## 🎨 Design

The app uses a clean, light mode-only aesthetic centered around a "broken white" (`#F5F5F0`) and "card white" (`#FAFAF8`) palette with a vibrant Lime Green (`#8DEE10`) accent color, giving it a playful and modern feel appropriate for a meme/photo-sharing platform.

## 👨‍💻 Developer Notes

*   Ensure to configure `firebase_options.dart` appropriately using the FlutterFire CLI before running the project.
*   API keys and endpoints (like the bootcamp API) should be managed via environment variables or a secure configuration file in a production environment.
