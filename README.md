# CareConnect661

CareConnect661 is a Flutter prototype for left-hand optimized and motor-friendly
mobile care workflows. The app is aligned to a Figma redesign and includes
phone-focused navigation, accessibility controls, and route-based workflow
screens for Week 4 implementation.

## Current Feature Set

- Phone shell with bottom navigation and left-side floating action button
- Accessibility settings (left-hand mode, high contrast, larger touch targets,
	text scaling)
- Core workflow screens:
	- Home dashboard
	- Patients list and patient detail
	- Visits list and visit detail
	- Forms list
	- Settings
	- Navigation menu
	- Review and approval
	- Confirmation
	- Validation error state
- Named routes with detail-screen argument passing
- Unit and widget tests for core flows

## Project Structure

- `assets/icons/`
- `assets/images/`
- `lib/models/`
- `lib/screens/`
- `lib/state/`
- `lib/theme/`
- `lib/utils/`
- `lib/widgets/`
- `test/unit/`
- `test/widget/`

## Requirements

- Flutter SDK (stable channel)
- Dart SDK (bundled with Flutter)
- Android Studio (for Android emulator)

Verify toolchain:

```bash
flutter doctor
```

## Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Confirm devices/emulators:

```bash
flutter devices
flutter emulators
```

3. If needed, launch emulator:

```bash
flutter emulators --launch Pixel_10
```

## Run

Run on Android emulator:

```bash
flutter run -d emulator-5554
```

Run on any available device:

```bash
flutter run
```

## Test

Run targeted suite used during implementation:

```bash
flutter test test/unit/handedness_layout_test.dart \
	test/unit/care_models_test.dart \
	test/widget_tests.dart \
	test/widget/left_hand_accessibility_test.dart
```

Run all tests:

```bash
flutter test
```

Collect coverage:

```bash
flutter test --coverage
```

## Accessibility Notes

- Primary actions are designed for left-thumb reach on phone layouts
- Touch target sizing scales with accessibility settings
- High-contrast mode is supported in app theme
- Text scale is wired through app-level `MediaQuery` `TextScaler`

## Design Reference

Figma redesign code export is included under:

- `plan/CareConnect Accessibility Redesign/`

Use this folder as the visual reference when continuing screen-alignment work.
