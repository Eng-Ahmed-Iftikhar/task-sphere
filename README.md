# Task Sphere

**Task Sphere** is a feature-rich Flutter productivity application demonstrating modern mobile app development practices. Built with clean architecture principles, it combines Firebase cloud services with local state management using Riverpod, offering users a seamless experience for managing tasks and tracking counters.

## 🎯 Overview

Task Sphere showcases a complete productivity workflow with:

- **Firebase Authentication** - Secure email/password and Google Sign-In support
- **Cloud Sync** - Real-time todo synchronization with Firestore
- **State Management** - Riverpod-powered reactive UI updates
- **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- **Responsive Design** - Adaptive layouts for all screen sizes and orientations
- **Offline Support** - Connectivity detection and offline queue management

## ✨ Key Features

### 🔐 Authentication

- Email and password login with validation
- Google Sign-In integration
- Firebase Authentication backend
- Secure token storage with encrypted preferences
- Session persistence

### ✅ Todo Management

- **Create** - Add todos with title and description
- **Read** - View all todos in a scrollable list
- **Update** - Edit todo title and description
- **Delete** - Remove todos with confirmation dialog
- **Complete** - Mark individual todos as completed
- **Bulk Actions** - Mark all incomplete todos as completed with one tap
- **Cloud Sync** - Real-time updates via Firestore
- **User-specific** - Todos scoped to authenticated user

### 🎲 Counter Feature

- Simple counter application for quick tallying
- Increment, decrement, and reset operations
- Clean, minimal UI

### 🎨 User Interface

- Animated splash screen with progress indicator
- Responsive Material Design layout
- Adaptive theming (light/dark mode support)
- Custom scaffold wrapper with refresh capability
- Intuitive navigation with Go Router
- Smooth transitions and animations

## 📁 Project Architecture

### Directory Structure

```plaintext
lib/
├── core/
│   ├── constants/        # App-wide constants and configuration
│   ├── error/            # Error handling and exceptions
│   ├── network/          # API client and network utilities
│   ├── providers/        # Global Riverpod providers
│   ├── router/           # Go Router configuration
│   ├── storage/          # Secure storage and persistence
│   ├── themes/           # Light and dark themes
│   ├── utils/            # Utility functions and helpers
│   └── widgets/          # Reusable UI components
├── features/
│   ├── auth/             # Authentication feature
│   │   ├── domain/       # Auth use cases and interfaces
│   │   ├── data/         # Auth repositories and data sources
│   │   └── presentation/ # Auth UI and providers
│   ├── counter/          # Counter feature
│   │   └── presentation/ # Counter UI
│   ├── home/             # Home dashboard
│   │   └── presentation/ # Home UI and navigation
│   └── todos/            # Todo management feature
│       ├── domain/       # Todo entities and repositories
│       ├── data/         # Firestore integration and models
│       └── presentation/ # Todo screens, widgets, and notifiers
├── main.dart             # App entry point
├── splash_screen.dart    # Animated splash screen
└── firebase_options.dart # Firebase configuration
```

### Architecture Pattern

Task Sphere follows **Clean Architecture** with clear layer separation:

- **Domain Layer** - Business logic, entities, and repository interfaces
- **Data Layer** - Firebase integration, repositories, and data sources
- **Presentation Layer** - UI, state management with Riverpod, and user interactions

## 🛠️ Technology Stack

### Core Framework

- **Flutter** 3.11.5+ - UI framework
- **Dart** - Programming language

### State Management

- **Riverpod** 3.3.2+ - Reactive state management
- **Flutter Riverpod** - Riverpod integration for Flutter

### Backend & Storage

- **Firebase Core** 4.10.0+ - Firebase initialization
- **Cloud Firestore** 6.5.0+ - Cloud database
- **Firebase Auth** 6.5.2+ - Authentication service
- **Google Sign-In** 7.2.0+ - Google authentication

### Local Storage & Security

- **Flutter Secure Storage** 10.3.1+ - Encrypted key-value storage
- **Shared Preferences** 2.5.5+ - Lightweight preferences
- **Hive** 2.2.3+ - Local database

### Networking & Connectivity

- **Dio** 5.9.2+ - HTTP client
- **Connectivity Plus** 7.1.1+ - Network connectivity detection

### Utilities & Tools

- **Go Router** 17.3.0+ - Declarative routing
- **FPDart** 1.2.0+ - Functional programming utilities
- **Equatable** 2.0.8+ - Value equality
- **Intl** 0.20.2+ - Internationalization
- **UUID** 4.5.3+ - Unique ID generation
- **Image Picker** 1.2.2+ - Image selection

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11.5 or higher
- Dart SDK 3.11.5 or higher
- A connected device or emulator
- Git for version control

### Installation & Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Eng-Ahmed-Iftikhar/task-sphere.git
   cd task-sphere
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Set up a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Download `google-services.json` for Android and place in `android/app/`
   - Download `GoogleService-Info.plist` for iOS and place in `ios/Runner/`
   - Enable Firebase Authentication, Firestore Database, and Google Sign-In

4. **Run the application:**

   ```bash
   flutter run
   ```

### Platform-Specific Commands

- **Android:**

   ```bash
   flutter run -d android
   ```

- **iOS:**

   ```bash
   flutter run -d ios
   ```

- **Web:**

   ```bash
   flutter run -d chrome
   ```

- **Windows:**

   ```bash
   flutter run -d windows
   ```

- **MacOS:**

   ```bash
   flutter run -d macos
   ```

## 📱 Features in Detail

### Todo Workflow

1. **Authentication** - Log in or create account
2. **Dashboard** - View available features (Counter, Todo App)
3. **Todo List** - View all your cloud-synced todos
4. **Create Todo** - Add new todo with title and description
5. **Edit Todo** - Modify existing todo details
6. **Complete Todo** - Mark individual or all todos as done
7. **Delete Todo** - Remove completed or unwanted todos
8. **Offline Support** - App queues operations when offline

### State Management Flow

- Riverpod `AsyncNotifierProvider` manages todo state
- Repository pattern abstracts data layer
- Use cases encapsulate business logic
- UI automatically updates via reactive providers
- Error handling with `Either<Failure, Success>` pattern

## 🔄 Data Flow

```plaintext
UI Layer (Screens/Widgets)
    ↓
Riverpod Providers & Notifiers
    ↓
Use Cases
    ↓
Repository Pattern
    ↓
Data Sources (Firestore, Local Storage)
    ↓
Firebase & Device Storage
```

## 🌐 API Integration

### Firestore Collections

- `users` - User account information
- `todos` - Todo items with user references

### Real-time Updates

- Real-time Listeners - Automatic UI updates on data changes
- Batch Operations - Efficient bulk updates (e.g., mark all as complete)

## 🔒 Security Features

- **Encrypted Storage** - Sensitive data stored securely
- **Authentication Required** - All operations behind auth wall
- **User Scoping** - Todos visible only to authenticated user
- **Network Check** - Verifies connectivity before operations
- **Error Boundaries** - Graceful error handling throughout

## 📊 Error Handling

The app implements comprehensive error handling:

- `ServerException` - Server-side errors
- `NetworkException` - Connectivity issues
- `UnauthorizedException` - Authentication failures
- `BadRequestException` - Invalid request data
- User-friendly error messages via SnackBars

## 🎨 Theme Support

- **Light Theme** - Optimized for daytime use
- **Dark Theme** - Reduced eye strain for low-light environments
- **System Adaptive** - Follows device theme preference
- **Custom Color Palette** - Consistent branding throughout

## 📝 Development Best Practices

- **Clean Code** - Readable and maintainable codebase
- **SOLID Principles** - Single responsibility, dependency injection
- **Code Organization** - Feature-based folder structure
- **Type Safety** - Strong typing throughout
- **Documentation** - Clear code comments and this README

## 🐛 Known Limitations

- First launch requires internet connection for Firebase initialization
- Firestore read/write quota applies (free tier: 50K reads/day)
- Image sync limited to URL references, not blob storage

## 🚧 Future Enhancements

- Task categories and tags
- Due dates and reminders
- Collaborative todo sharing
- Cloud backup and export
- Offline-first synchronization
- Task priority levels
- Search and filtering
- Analytics dashboard

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

Eng Ahmed Iftikhar

- GitHub: [@Eng-Ahmed-Iftikhar](https://github.com/Eng-Ahmed-Iftikhar)

## 🙏 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Task Sphere - Manage your tasks, master your productivity! 🚀
