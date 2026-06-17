# CareConnect661

CareConnect661 is a Flutter mobile prototype focused on left-hand accessibility
and motor-friendly interactions. This implementation demonstrates an
accessibility-first user flow with authentication, onboarding, profile/settings,
and feature discovery screens.

## What The App Does

- Provides a demo login flow and accessibility onboarding wizard
- Applies user accessibility preferences (handedness, contrast, touch targets,
  text scaling) across the app
- Uses a bottom navigation shell to access Home, Features, Notifications,
  and Settings
- Includes profile and edit-profile screens plus feature detail drill-down

## Screen List

1. Login
2. Accessibility Onboarding
3. Home Dashboard
4. Features List
5. Feature Detail
6. Notifications
7. Profile
8. Edit Profile
9. Settings

## Architecture Choices

- State management: `provider` + `ChangeNotifier` via `AppState`
- Navigation: `go_router` with route redirects and a `ShellRoute`
- Models/state separated from UI in `lib/models/` and `lib/state/`

## Requirements

- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Android Studio (for emulator)

Check toolchain:

```bash
flutter doctor
```

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. If Android host files are missing (fresh branch clone), regenerate them:

```bash
flutter create --platforms=android .
```

3. Verify available devices/emulators:

```bash
flutter devices
flutter emulators
```

4. Launch emulator if needed (replace with one from `flutter emulators` output):

```bash
flutter emulators --launch <emulator_id>
```

## Run

Run on Android emulator:

```bash
flutter run -d emulator-5554
```

Run on default device:

```bash
flutter run
```

## Demo Login

This prototype uses demo authentication logic (no backend service).

- Email: any non-empty value
- Password: at least 6 characters

Example:

- Email: `demo@careconnect.com`
- Password: `123456`

## Test

Run all tests:

```bash
flutter test
```

Run analyzer:

```bash
flutter analyze
```

## Coverage

Generate coverage:

```bash
flutter test --coverage
```

Compute summary percentage:

```bash
awk -F: '/^LF:/{lf+=$2} /^LH:/{lh+=$2} END { if (lf>0) printf "Coverage: %.2f%% (%d/%d)\n", (lh/lf)*100, lh, lf; else print "Coverage: N/A" }' coverage/lcov.info
```

Generate HTML report:

```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Accessibility Notes

- Semantic labels are applied throughout interactive UI controls
- Minimum touch targets are enforced in primary action components
- High-contrast mode and text scaling are user-configurable
- Left-hand optimization is built into navigation placement and core controls

## React Native Implementation (Week 5)

A parallel React Native implementation lives in `react-native/`. It matches the
same 9 screens and accessibility features as the Flutter version.

Quick start:

```bash
cd react-native
npm install
npm start          # start Metro bundler
npm run android    # run on Android emulator (separate terminal)
```

Required React Native Android dependencies:

- JDK 17-20 (this repo is configured to use JDK 17 for Gradle Android builds)
- Android SDK Platform 36 + Build-Tools 36.0.0
- Android NDK 27.1.12297006
- CMake 3.22.1
- `adb` and `emulator` available on `PATH`

See [react-native/README.md](react-native/README.md) for full setup, iOS
instructions, and test/coverage commands.

## Design Reference

- `plan/CareConnect Accessibility Redesign/`
