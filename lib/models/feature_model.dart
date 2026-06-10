import 'package:flutter/material.dart';

/// Represents a single accessibility feature in CareConnect.
class FeatureModel {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final IconData icon;
  final String category;
  final List<String> steps;
  final bool isEnabled;

  const FeatureModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.icon,
    required this.category,
    required this.steps,
    this.isEnabled = false,
  });

  FeatureModel copyWith({bool? isEnabled}) => FeatureModel(
        id: id,
        title: title,
        shortDescription: shortDescription,
        fullDescription: fullDescription,
        icon: icon,
        category: category,
        steps: steps,
        isEnabled: isEnabled ?? this.isEnabled,
      );
}

/// Static catalogue of all accessibility features shipped with CareConnect.
class FeatureData {
  FeatureData._();

  static const List<FeatureModel> all = [
    FeatureModel(
      id: 'left-nav',
      title: 'Left-Hand Navigation',
      shortDescription:
          'Moves primary controls to the left edge for easier one-handed reach.',
      fullDescription:
          'Repositions all primary navigation controls to the left edge of the screen, '
          'allowing left-hand dominant users to access core functions without stretching '
          'or repositioning their grip. Directly satisfies WCAG 2.5.1 (Pointer Gestures) '
          'and the team-assigned WCAG 2.5.5 (Target Size) constraint.',
      icon: Icons.swap_horiz_rounded,
      category: 'Navigation',
      steps: [
        'Open Settings from the bottom navigation bar.',
        'Toggle "Left-Hand Mode" to ON.',
        'Navigation controls will shift to the left edge.',
        'Restart the app if controls do not reposition immediately.',
      ],
    ),
    FeatureModel(
      id: 'large-targets',
      title: 'Large Touch Targets',
      shortDescription:
          'Enlarges all interactive elements beyond the 48 dp WCAG minimum.',
      fullDescription:
          'Expands buttons and tap areas to 60×60 dp, reducing the precision required '
          'for taps. Particularly helpful for users with limited fine motor control or '
          'those operating the device one-handed. Exceeds WCAG 2.5.5 (Target Size).',
      icon: Icons.touch_app_rounded,
      category: 'Motor Accessibility',
      steps: [
        'Go to Settings > Accessibility.',
        'Enable "Large Touch Targets".',
        'All buttons and tap areas will expand.',
        'Scroll to review the updated layouts.',
      ],
    ),
    FeatureModel(
      id: 'high-contrast',
      title: 'High Contrast Mode',
      shortDescription: 'Switches to a dark theme with ≥7:1 contrast ratios (WCAG AAA).',
      fullDescription:
          'Applies a high-contrast dark theme that exceeds WCAG AA requirements. '
          'Reduces eye strain in bright environments and improves visibility for users '
          'with low vision or photosensitivity. Toggle at any time from Settings.',
      icon: Icons.contrast_rounded,
      category: 'Visual',
      steps: [
        'Navigate to Settings.',
        'Toggle "High Contrast Mode".',
        'The theme switches immediately — no restart required.',
        'Toggle again to return to the standard theme.',
      ],
    ),
    FeatureModel(
      id: 'text-scaling',
      title: 'Dynamic Text Scaling',
      shortDescription: 'Adjusts text size without breaking layouts.',
      fullDescription:
          'Sets a custom text scale factor within CareConnect, independent of the '
          'device\'s global font size. All layouts adapt gracefully — no truncation '
          'or overflow. Supports WCAG 1.4.4 (Resize Text).',
      icon: Icons.text_fields_rounded,
      category: 'Visual',
      steps: [
        'Open Settings.',
        'Use the Text Size slider to adjust scale (0.8× – 2.0×).',
        'Layouts update live as you drag.',
        'Tap "Reset" to return to the default 1.0× scale.',
      ],
    ),
    FeatureModel(
      id: 'voice-input',
      title: 'Voice Input Assistance',
      shortDescription: 'Enables hands-free text entry via the device microphone.',
      fullDescription:
          'Integrates with the device\'s built-in speech recognition to allow text '
          'entry without typing. Useful for users with limited hand mobility or those '
          'who prefer voice-driven interaction.',
      icon: Icons.mic_rounded,
      category: 'Motor Accessibility',
      steps: [
        'Ensure microphone permission is granted in device Settings.',
        'Tap the microphone icon in any text field.',
        'Speak clearly — text is transcribed in real time.',
        'Tap ✓ to confirm or ✕ to cancel.',
      ],
    ),
    FeatureModel(
      id: 'simple-nav',
      title: 'Simplified Navigation',
      shortDescription: 'Reduces menu depth to a maximum of two levels.',
      fullDescription:
          'Restructures the navigation hierarchy so that every destination is reachable '
          'within two taps from the home screen. Reduces cognitive load and supports '
          'WCAG 2.4.1 (Bypass Blocks) and 2.4.3 (Focus Order).',
      icon: Icons.menu_open_rounded,
      category: 'Navigation',
      steps: [
        'Simplified navigation is active by default.',
        'Common destinations appear in the bottom navigation bar.',
        'Less-used screens are grouped under "More".',
        'The back button always returns you exactly one level up.',
      ],
    ),
    FeatureModel(
      id: 'reachability',
      title: 'Reachability Zones',
      shortDescription: 'Overlay showing comfortable left-thumb reach areas.',
      fullDescription:
          'Renders a semi-transparent colour-coded overlay indicating the comfortable '
          'thumb-reach zone for left-hand use. Green = easy reach, Yellow = stretch, '
          'Red = avoid. Intended as a design-review aid for developers.',
      icon: Icons.accessibility_new_rounded,
      category: 'Navigation',
      steps: [
        'Go to Settings > Developer Tools.',
        'Enable "Show Reachability Zones".',
        'A coloured overlay appears on every screen.',
        'Disable when finished reviewing.',
      ],
    ),
    FeatureModel(
      id: 'motor-gestures',
      title: 'Motor-Friendly Gestures',
      shortDescription: 'Replaces complex gestures with single-tap alternatives.',
      fullDescription:
          'Substitutes multi-finger gestures, long-presses, and swipe-to-delete '
          'patterns with visible single-tap action buttons. Each destructive action '
          'requires a confirmation dialog, preventing accidental activation. '
          'Supports WCAG 2.5.1 (Pointer Gestures).',
      icon: Icons.gesture_rounded,
      category: 'Motor Accessibility',
      steps: [
        'Motor-friendly gestures are active by default when Left-Hand Mode is on.',
        'Swipe actions are replaced by visible icon buttons.',
        'Long-press menus become overflow icon-button menus.',
        'Confirmation dialogs prevent accidental destructive actions.',
      ],
    ),
  ];
}
