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
- Android Studio (for Android emulator) or Xcode (for iOS simulator, macOS only)

Check your environment:

```bash
npx react-native doctor
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
