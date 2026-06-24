import 'package:care_connect661/models/feature_model.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature model and app state accessibility behavior', () {
    testWidgets('Feature model preserves constructor values',
        (WidgetTester tester) async {
      final feature = FeatureModel(
        id: '1',
        title: 'Test Feature',
        shortDescription: 'Short description',
        fullDescription: 'A full test feature description',
        icon: Icons.favorite,
        category: 'Health',
        steps: ['Step 1', 'Step 2'],
      );

      expect(feature.id, '1');
      expect(feature.title, 'Test Feature');
      expect(feature.shortDescription, 'Short description');
      expect(feature.category, 'Health');
      expect(feature.isEnabled, isFalse);
    });

    testWidgets('Feature model copyWith updates enabled flag', (WidgetTester tester) async {
      final original = FeatureModel(
        id: '1',
        title: 'Test Feature',
        shortDescription: 'Short description',
        fullDescription: 'A full test feature description',
        icon: Icons.favorite,
        category: 'Health',
        steps: ['Step 1', 'Step 2'],
        isEnabled: false,
      );

      final updated = original.copyWith(isEnabled: true);
      expect(updated.isEnabled, isTrue);
      expect(updated.title, 'Test Feature');
    });

    testWidgets('AppState stores text scale changes', (WidgetTester tester) async {
      final appState = AppState();

      // Verify initial text scale
      expect(appState.textScaleFactor, 1.0);

      // Change text scale
      appState.setTextScaleFactor(1.4);
      expect(appState.textScaleFactor, 1.4);

      // Verify mid-range
      appState.setTextScaleFactor(1.2);
      expect(appState.textScaleFactor, 1.2);

      // Verify we can reset
      appState.setTextScaleFactor(1.0);
      expect(appState.textScaleFactor, 1.0);
    });

    testWidgets('AppState toggles high contrast mode', (WidgetTester tester) async {
      final appState = AppState();

      // Verify initial state
      expect(appState.highContrast, isFalse);

      // Toggle high contrast
      appState.setHighContrast(true);
      expect(appState.highContrast, isTrue);

      // Toggle back
      appState.setHighContrast(false);
      expect(appState.highContrast, isFalse);

      // Multiple toggles
      appState.setHighContrast(true);
      expect(appState.highContrast, isTrue);
    });

    testWidgets('AppState toggles large touch targets', (WidgetTester tester) async {
      final appState = AppState();

      // Verify initial state
      expect(appState.largeTargets, isTrue);

      // Toggle large targets
      appState.setLargeTargets(false);
      expect(appState.largeTargets, isFalse);

      // Toggle back
      appState.setLargeTargets(true);
      expect(appState.largeTargets, isTrue);

      // Multiple toggles
      appState.setLargeTargets(false);
      expect(appState.largeTargets, isFalse);
    });

    testWidgets('AppState toggles left-handed mode', (WidgetTester tester) async {
      final appState = AppState();

      // Initial state should be left-handed
      expect(appState.leftHandMode, isTrue);

      // Toggle to right-handed
      appState.setLeftHandMode(false);
      expect(appState.leftHandMode, isFalse);

      // Verify multiple toggles work
      appState.setLeftHandMode(true);
      expect(appState.leftHandMode, isTrue);

      appState.setLeftHandMode(false);
      expect(appState.leftHandMode, isFalse);

      appState.setLeftHandMode(true);
      expect(appState.leftHandMode, isTrue);
    });

    testWidgets('AppState updates all accessibility settings together', (WidgetTester tester) async {
      final appState = AppState();

      // Set all to non-default
      appState.setLeftHandMode(false);
      appState.setHighContrast(true);
      appState.setLargeTargets(false);
      appState.setTextScaleFactor(1.3);

      // Verify all changes
      expect(appState.leftHandMode, isFalse);
      expect(appState.highContrast, isTrue);
      expect(appState.largeTargets, isFalse);
      expect(appState.textScaleFactor, 1.3);

      // Reset all to defaults
      appState.setLeftHandMode(true);
      appState.setHighContrast(false);
      appState.setLargeTargets(true);
      appState.setTextScaleFactor(1.0);

      // Verify reset
      expect(appState.leftHandMode, isTrue);
      expect(appState.highContrast, isFalse);
      expect(appState.largeTargets, isTrue);
      expect(appState.textScaleFactor, 1.0);
    });

    testWidgets('AppState notifies listeners when accessibility settings change', (WidgetTester tester) async {
      final appState = AppState();
      int notifyCount = 0;

      appState.addListener(() {
        notifyCount++;
      });

      // Each setter should notify listeners
      appState.setLeftHandMode(false);
      expect(notifyCount, greaterThan(0));

      int countBefore = notifyCount;
      appState.setHighContrast(true);
      expect(notifyCount, greaterThan(countBefore));

      countBefore = notifyCount;
      appState.setLargeTargets(false);
      expect(notifyCount, greaterThan(countBefore));
    });

    testWidgets('AppState accepts text scale boundary values', (WidgetTester tester) async {
      final appState = AppState();

      // Test minimum
      appState.setTextScaleFactor(1.0);
      expect(appState.textScaleFactor, 1.0);

      // Test maximum
      appState.setTextScaleFactor(1.4);
      expect(appState.textScaleFactor, 1.4);

      // Test values between
      appState.setTextScaleFactor(1.05);
      expect(appState.textScaleFactor, 1.05);

      appState.setTextScaleFactor(1.15);
      expect(appState.textScaleFactor, 1.15);

      appState.setTextScaleFactor(1.25);
      expect(appState.textScaleFactor, 1.25);

      appState.setTextScaleFactor(1.35);
      expect(appState.textScaleFactor, 1.35);
    });

    testWidgets('AppState remains consistent after rapid accessibility changes', (WidgetTester tester) async {
      final appState = AppState();

      // Rapid toggles
      for (int i = 0; i < 10; i++) {
        appState.setLeftHandMode(i % 2 == 0);
        appState.setHighContrast(i % 2 != 0);
      }

      // Should end in correct state (since 9 is odd)
      expect(appState.leftHandMode, isFalse);
      expect(appState.highContrast, isTrue);
    });
  });
}
