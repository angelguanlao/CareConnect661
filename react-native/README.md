# CareConnect — React Native (Week 5)

React Native implementation of CareConnect, matching the Flutter version's
accessibility-first user flow with login, onboarding, dashboard, features,
notifications, profile, and settings screens.

## Demo Login

- Email: any non-empty value (e.g. `demo@careconnect.com`)
- Password: at least 6 characters (e.g. `123456`)

## Requirements

- Node.js >= 22
- React Native CLI: `@react-native-community/cli`
- Java Development Kit (JDK) 17-20 (JDK 25 is not supported by RN Android builds)
- Android Studio (for Android emulator) or Xcode (for iOS simulator, macOS only)
- Android SDK components:
	- Android SDK Platform 36
	- Android SDK Build-Tools 36.0.0
	- Android NDK 27.1.12297006
	- CMake 3.22.1

Install JDK 17 on macOS (Homebrew):

```bash
brew install openjdk@17
```

React Native Android in this repo is pinned to JDK 17 via
`android/gradle.properties`.

Check your environment:

```bash
npx react-native doctor
```

## Android Environment Variables (macOS)

Add Android SDK tools to your shell path:

```bash
echo '\n# Android SDK\nexport ANDROID_HOME=$HOME/Library/Android/sdk\nexport PATH=$PATH:$ANDROID_HOME/platform-tools\nexport PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.zshrc
source ~/.zshrc
```

Verify commands are available:

```bash
which adb
which emulator
```

## Setup

Install dependencies:

```bash
cd react-native
npm install
```

## Run on Android

Start Metro bundler:

```bash
cd react-native
npm start
```

In a separate terminal, run on Android emulator:

```bash
cd react-native
npm run android
```

If no emulator is running, start one first:

```bash
emulator -list-avds
emulator -avd Pixel_10
```

## Run on iOS (macOS only)

Install CocoaPods:

```bash
cd react-native/ios
bundle install
bundle exec pod install
cd ..
```

Run on iOS simulator:

```bash
npm run ios
```

## Test

Run all tests:

```bash
cd react-native
npm test
```

Run with coverage:

```bash
cd react-native
npm test -- --coverage
```

Coverage is configured in [jest.config.js](jest.config.js) (`collectCoverageFrom`,
`lcov`/`text`/`html` reporters → `coverage/`).

## Test Layers

| Layer | Location | Tooling | What it covers |
|-------|----------|---------|----------------|
| Unit | `__tests__/AppState.test.ts`, `__tests__/Feature.test.ts` | Jest | store logic, models |
| Integration (component) | `__tests__/*Screen*.test.tsx` | Jest + `@testing-library/react-native` | full screens rendered with the real provider + navigation, user interactions |
| E2E | `.maestro/*.yaml` | Maestro | the app driven on a device across screens |

### Integration / component tests

These render whole screens against the real `AppProvider` and exercise user flows
(login validation, onboarding selection, feature search/toggle, settings). They run
on the host with no device:

```bash
cd react-native
npm test
```

### E2E tests (Maestro)

End-to-end flows live in [`.maestro/`](.maestro/):

- `login_and_onboard.yaml` — Login → 3-step onboarding → Home (reusable).
- `accessibility_journey.yaml` — reaches Home, changes accessibility settings,
  enables a feature, returns Home.

**Prerequisites:** the app must be **installed on a running device/emulator**, and
for a debug build **Metro must be running** (`npm start`). Install Maestro once:

```bash
# macOS / Linux
curl -fsSL "https://get.maestro.mobile.dev" | bash
# Windows (PowerShell) — install via WSL, or download from the Maestro releases page
```

Run the flows:

```bash
cd react-native
maestro test .maestro/login_and_onboard.yaml
maestro test .maestro                       # run every flow in the folder
```

## Windows Build Notes (gotchas)

The RN 0.86 New Architecture build can fail on Windows for two unrelated reasons —
both machine-level, neither requires editing the repo:

1. **JDK pinned to a non-Windows path.** `android/gradle.properties` may pin
   `org.gradle.java.home` to a macOS path. Override it in your **user-level**
   `~/.gradle/gradle.properties` (not committed) with a JDK 17–21 install, e.g.:
   ```properties
   org.gradle.java.home=C:/Program Files/Android/Android Studio/jbr
   ```
   (Setting `JAVA_HOME` alone is **not** enough — the project file's value overrides it.)

2. **`ninja: Filename longer than 260 characters`** during the C++ codegen build.
   Windows long paths must be enabled *and* a modern ninja used — the NDK's bundled
   ninja 1.10.2 predates long-path support. Enable long paths
   (`LongPathsEnabled = 1`, already default on many systems) and replace
   `%ANDROID_HOME%\cmake\3.22.1\bin\ninja.exe` with **ninja ≥ 1.11**
   ([download](https://github.com/ninja-build/ninja/releases)), then clear
   `android/app/.cxx` and rebuild.

## Architecture Choices

- State management: Custom `AppStore` (pub/sub) + React Context via `AppProvider`
- Navigation: `@react-navigation/native` with stack + bottom-tab navigators
- Screens and state separated into `src/screens/`, `src/state/`, `src/models/`

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
