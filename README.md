# Task Sphere

Task Sphere is a Flutter productivity app that demonstrates a polished onboarding flow, authentication UI, a counter feature, and a local todo manager with persistent storage.

## Overview

Task Sphere includes:

- Animated splash screen with progress indicator
- Login screen with email and password validation
- Home dashboard with navigation to app features
- Counter screen with increment, decrement, and reset
- Todo manager with create, update, complete, and delete actions
- Local persistence using `SharedPreferences`
- Adaptive theming for light and dark modes

## Features

- **Animated splash screen** with logo motion and typing-style title
- **Login workflow** with form validation and success feedback
- **Counter feature** for quick tallying
- **Todo list** with:
  - Add new todos
  - Mark todos as completed
  - Edit existing todos
  - Delete todos
  - Persistent storage across app launches
- **Responsive layout** using custom scaffold wrapper
- **Named route navigation** for easy feature access

## Project Structure

- `lib/main.dart` - App entry point
- `lib/splash_screen.dart` - Animated launch screen
- `lib/features/auth` - Login UI and form validation
- `lib/features/home` - Home screen and feature navigation
- `lib/features/counter` - Counter screen implementation
- `lib/features/todos` - Todo CRUD screens, model, widgets, and persistence
- `lib/core` - Theme, constants, routes, and reusable layout widgets

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK installed
- A connected device or emulator
- Optional: Android Studio, Xcode, or VS Code with Flutter extension

### Setup

1. Clone the repository:

```bash
git clone https://github.com/Eng-Ahmed-Iftikhar/task-sphere.git
cd task-sphere
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### Platform-specific commands

- Android:

```bash
flutter run -d android
```

- iOS:

```bash
flutter run -d ios
```

- Web:

```bash
flutter run -d chrome
```

- Windows:

```bash
flutter run -d windows
```

## Notes

- Todos are stored locally using `SharedPreferences` under the key `todos`.
- Login is a local UI flow and does not connect to a remote authentication service.
- The app theme follows the device brightness and uses a custom color palette.

## Dependencies

- `flutter`
- `cupertino_icons`
- `shared_preferences`

## Version

- `1.0.0+1`

---

Feel free to extend Task Sphere by adding user accounts, task categories, or cloud synchronization.