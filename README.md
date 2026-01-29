
# test_app

## Overview

**test_app** is a simple cross-platform Flutter game where you control a car on a road using left and right buttons. The game features animated road markings and supports both portrait and landscape orientations. It is designed as a learning project for Flutter development and demonstrates custom painting, animation, and responsive UI.

## Features

- Move a car left and right using on-screen buttons
- Animated road with moving markings (portrait and landscape)
- Responsive layout for different device orientations
- Custom painter for road effects
- Asset image usage for the car
- Runs on Android, iOS, Web, Windows, macOS, and Linux

## Project Structure

- `lib/main.dart` — Main app code, UI, game logic, and custom painter
- `assets/martin.png` — Car image asset
- `test/widget_test.dart` — Example widget test (default)
- Platform folders: `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`

## Getting Started

1. **Install Flutter:** [Flutter installation guide](https://docs.flutter.dev/get-started/install)
2. **Get dependencies:**
	```
	flutter pub get
	```
3. **Run the app:**
	```
	flutter run
	```
	You can specify a device or platform with `-d` (e.g., `flutter run -d chrome` for web).

## Assets

- The car image is located at `assets/martin.png`. Ensure this file exists and is referenced in `pubspec.yaml` under `flutter/assets` if you add more assets.

## Testing

Run widget tests with:
```
flutter test
```

## Customization

- Replace `assets/martin.png` with your own car image if desired.
- Modify `lib/main.dart` to change game logic, appearance, or controls.

## License

This project is for educational purposes. See [LICENSE](LICENSE) if present.

---
