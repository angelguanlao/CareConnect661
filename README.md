# CareConnect661

### Accessible, left‑hand‑optimized Flutter application scaffold

CareConnect661 is a Flutter starter application designed with a singular purpose: make mobile interaction easier for users with limited reach, motor constraints, or one‑handed device use. The project provides a clean, extensible foundation for building medical, wellness, or assistive‑technology applications with accessibility at the core.

## Key Features


## 🌟 What the App Does
CareConnect661 provides a foundation for building an accessible medical or wellness‑support application. The scaffold includes:

- A left‑edge‑optimized UI where primary controls sit within natural thumb reach
- Large, high‑contrast interactive elements for improved visibility and motor accessibility
- Adjustable text scaling without breaking layout integrity
- A modular architecture that supports adding screens, models, and state logic cleanly
- A starting point for symptom logging, reminders, quick actions, and emergency‑access features

This project is intentionally minimal — it gives you the bones of an accessible Flutter app so you can layer in features without fighting the framework.

## Included structure

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

## Accessibility focus

CareConnect661 includes early-stage accessibility considerations:

- Left-edge primary controls  
    Ensures the most frequently used actions are reachable by the left thumb without stretching.
- Larger touch targets  
    Buttons and interactive elements meet or exceed the recommended 48×48 dp minimum.
- High-contrast theme support  
    Improves visibility for users with low vision or visual fatigue.
- Adjustable text scaling  
    Typography responds cleanly to system-level text size changes without breaking layout.
- Reduced cognitive load  
    Simple navigation, predictable placement, and minimal visual noise.

These principles guide all UI decisions in the scaffold.

## Tech Stack
- Flutter
- Dart
- Provider (state management)
- Navigator 2.0 (routing)
- Figma (theming foundation)

## Roadmap
- Add left‑hand‑optimized navigation rail
- Introduce customizable reachability zones
- Add voice‑assisted input for motor‑limited users
- Implement onboarding for accessibility preferences
- Add sample screens demonstrating ergonomic layouts
- Expand widget library with adaptive components

## How to run the App
### Prerequisites
- Flutter SDK installed (3.x recommended)
- Dart SDK included with Flutter
- VS Code or Android Studio
- A connected device or emulator

### Clone the repository
- git clone https://github.com/<your-username>/CareConnect661.git
- cd CareConnect661

### Install dependencies
- flutter pub get

### Run the App
- flutter run

### Run tests
- flutter test

## 📱 Screens Included
The scaffold includes placeholder screens you can expand as you build out the app:
- HomeScreen — left‑aligned primary actions, large buttons, high‑contrast layout
- LogScreen — structure for quick symptom/event logging
- SettingsScreen — text scaling, contrast, and accessibility toggles
- OnboardingScreen — explains left‑hand optimization and quick‑log features
- EmergencyScreen — reserved for a large, left‑aligned SOS action

## 🧭 State Management & Navigation
### State Management: Provider (Simple + Scalable)
The scaffold uses Provider for lightweight state management.
It’s ideal for early‑stage apps because it’s:
- Easy to reason about
- Minimal boilerplate
- Compatible with Riverpod or Bloc if you scale later

### Navigation: Flutter’s Navigator 2.0 (Declarative Routing)
The project uses a simple Navigator 2.0 setup with:
- A central AppRouter
- Typed route definitions
- Left‑hand‑friendly back navigation patterns
- Room to expand into nested navigation if needed

## Architecture Diagram

                          ┌──────────────────────────────┐
                          │        main.dart              │
                          │  - App entry point            │
                          │  - Initializes Provider +     │
                          │    AppRouter                  │
                          └───────────────┬──────────────┘
                                          │
                                          ▼
                    ┌──────────────────────────────────────────┐
                    │                AppRouter                  │
                    │  - Navigator 2.0 declarative routing      │
                    │  - Defines screen map + route parsing     │
                    └───────────────┬──────────────────────────┘
                                    │
                                    ▼
        ┌──────────────────────────────────────────────────────────────────┐
        │                            UI Layer                              │
        │──────────────────────────────────────────────────────────────────│
        │ screens/                                                         │
        │   - HomeScreen                                                   │
        │   - LogScreen                                                    │
        │   - SettingsScreen                                               │
        │   - OnboardingScreen                                             │
        │   - EmergencyScreen                                              │
        │ widgets/                                                         │
        │   - Shared components (buttons, cards, layout helpers)           │
        └───────────────────────┬──────────────────────────────────────────┘
                                │
                                ▼
        ┌──────────────────────────────────────────────────────────────────┐
        │                        State Management                          │
        │──────────────────────────────────────────────────────────────────│
        │ state/                                                           │
        │   - Provider-based app state                                     │
        │   - Accessibility settings provider                              │
        │   - UI preferences provider                                      │
        │                                                                  │
        │ Provider responsibilities:                                       │
        │   • Holds reactive UI state                                      │
        │   • Exposes change notifiers                                     │
        │   • Decouples UI from logic                                      │
        └───────────────────────┬──────────────────────────────────────────┘
                                │
                                ▼
        ┌──────────────────────────────────────────────────────────────────┐
        │                          Theme Layer                             │
        │──────────────────────────────────────────────────────────────────│
        │ theme/                                                           │
        │   - Color tokens                                                 │
        │   - Typography scale                                             │
        │   - Spacing system                                               │
        │   - High-contrast + left-hand ergonomics                         │
        └───────────────────────┬──────────────────────────────────────────┘
                                │
                                ▼
        ┌──────────────────────────────────────────────────────────────────┐
        │                       Core Utilities (optional)                  │
        │──────────────────────────────────────────────────────────────────│
        │ utils/                                                           │
        │   - Layout helpers                                               │
        │   - Accessibility utilities                                      │
        │   - Device metrics                                               │
        └──────────────────────────────────────────────────────────────────┘

## 🔍 How to Use This Diagram
This diagram is designed to:
- Show clear separation of concerns
- Highlight the Provider + Navigator 2.0 architecture
- Make onboarding easier for collaborators
- Provide a visual anchor for your README
- It also mirrors the structure you’ve already built, so it feels native to the repo.