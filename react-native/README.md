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
