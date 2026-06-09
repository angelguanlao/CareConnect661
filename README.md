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

## Screen List

- Home dashboard
- Patients list
- Patient detail
- Visits list
- Visit detail
- Forms
- Settings
- Navigation menu
- Review & approval
- Confirmation
- Validation errors

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

Compute summary percentage:

```bash
awk -F: '/^LF:/{lf+=$2} /^LH:/{lh+=$2} END { if (lf>0) printf "Coverage: %.2f%% (%d/%d)\n", (lh/lf)*100, lh, lf; else print "Coverage: N/A" }' coverage/lcov.info
```

Generate HTML report (macOS):

```bash
brew install lcov
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Week 4 Accessibility Evidence

Assigned team focus: left-hand and motor-friendly interaction patterns integrated
into navigation and core workflows.

- Left-hand positioning:
	- Navigation trigger and primary floating action are left-reachable in phone
		shell layouts
	- Wide layouts pin the accessibility panel to the left side
- Semantic labeling:
	- Interactive controls include semantic labels or tooltips across dashboard,
		list, and form flows
	- Progress and selection controls expose readable state values
- Touch target minimums:
	- Buttons and list controls are configured with larger minimum heights,
		especially when `Larger touch targets` is enabled
- Dynamic text scaling:
	- App-level text scaling is propagated through `MediaQuery` with
		`TextScaler.linear(...)`
- Error/empty/loading handling:
	- Validation errors are shown in a dedicated route
	- Patients, visits, and forms render explicit empty states
	- Pull-to-refresh provides loading affordances for list-based screens

### Screen Reader Verification Checklist

Use TalkBack (Android) or VoiceOver (iOS), then verify:

1. Focus order reaches top controls, content cards, and primary actions.
2. Action buttons announce meaningful labels (not just icon names).
3. Toggles announce on/off state and slider announces current text size value.
4. Progress indicators announce completion percentages.
5. Empty-state messages are announced as informative content.

## Design Reference

Figma redesign code export is included under:

- `plan/CareConnect Accessibility Redesign/`

Use this folder as the visual reference when continuing screen-alignment work.
