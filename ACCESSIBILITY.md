# CareConnect Flutter Accessibility

This document describes the accessibility implementation in the Flutter version of
CareConnect, which lives in `lib/`. The React Native version has its own report in
[react-native/ACCESSIBILITY.md](react-native/ACCESSIBILITY.md).

The application targets WCAG 2.1 Level AA. It is built to work with TalkBack on
Android and VoiceOver on iOS, and the same Flutter `Semantics` annotations drive both
screen readers.

## Accessible Labels

Every interactive control carries a semantic label so that a screen reader announces
its purpose rather than its raw contents.

- The login form wraps each field in a `Semantics` node with a descriptive label and
  the `textField` flag. See [lib/screens/login_screen.dart](lib/screens/login_screen.dart).
- The password visibility control announces "Show password" or "Hide password" and is
  marked as a button.
- The primary actions use the shared `AccessibleButton` widget, which accepts a
  `semanticLabel` such as "Sign in to CareConnect".
- The onboarding choice cards expose a label, the `button` role, and a `selected`
  state so the current handedness choice is announced.
  See [lib/screens/accessibility_onboarding_screen.dart](lib/screens/accessibility_onboarding_screen.dart).

## Color Contrast

The light and dark themes are defined in `lib/theme/app_theme.dart` and aim for the
WCAG 2.1 AA ratios of 4.5:1 for normal text and 3:1 for large text and user interface
components. The high contrast mode applies a dark theme intended to reach roughly 7:1,
which exceeds the AA requirement. Control state is communicated through both text and
the `selected` semantic flag rather than color alone, which satisfies the use of color
success criterion.

## Focus and Navigation Order

The reading and focus order follows the visual order from top to bottom on each
screen. Section and page titles are wrapped in `Semantics(header: true)` so a screen
reader user can move heading by heading. The onboarding progress indicator carries a
"Step N of 3" label so the user always knows their position in the wizard.

## Screen Reader Support

The application is designed to be operated entirely with TalkBack or VoiceOver. Form
errors are placed in a `Semantics(liveRegion: true)` container so they are announced
as soon as they appear. Sliders and switches carry labels that describe both the
control and its current value, for example "Text scale slider, current value 1.0".

## Accessible Components

The implementation relies on real semantic roles rather than visual styling alone.
Buttons report the `button` role, the handedness options report a `selected` state,
the text size control reports the `slider` role, and headings report the `header`
role. The `AccessibleButton` widget also enforces a minimum touch target height of 48
density independent pixels, which meets the WCAG 2.5.5 target size guidance.

## Relation to the Assigned Scenario

CareConnect is built for left handed users and users with motor accessibility needs.
The accessibility work supports that group directly. The onboarding flow asks for the
user's dominant hand and stores the preference. High contrast mode and text scaling
are applied globally through `MaterialApp` in [lib/main.dart](lib/main.dart), so a
user with low vision can make the whole application easier to read. The large touch
target preference and the minimum 48 dp targets reduce the precision required to
operate the app, which helps users with limited dexterity. Because the target users
rely on assistive technology, the labels, roles, and live regions described above are
essential to the product rather than an optional extra.

## How to Verify

1. Run the app on a device or emulator with `flutter run`.
2. Enable TalkBack on Android or VoiceOver on iOS.
3. Swipe through each screen and confirm that every control is reachable, correctly
   named, and reports its role and state.
4. Confirm that decorative icons are skipped and that errors are announced
   automatically.
