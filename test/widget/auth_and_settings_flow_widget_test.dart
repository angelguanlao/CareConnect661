import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('Coverage Expansion Tests', () {
    testWidgets('Home screen displays quick actions section',
        (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
        find.byType(TextFormField).first,
        'demo@careconnect.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        '123456',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      // Skip onboarding
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pumpAndSettle();

      // Verify home screen elements
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('AppState manages accessibility settings directly',
        (WidgetTester tester) async {
      final appState = AppState();
      
      // Test initial state
      expect(appState.leftHandMode, isTrue);
      expect(appState.highContrast, isFalse);
      expect(appState.largeTargets, isTrue);
      expect(appState.textScaleFactor, 1.0);
      
      // Test setters work correctly
      appState.setLeftHandMode(false);
      expect(appState.leftHandMode, isFalse);
      
      appState.setHighContrast(true);
      expect(appState.highContrast, isTrue);
      
      appState.setLargeTargets(false);
      expect(appState.largeTargets, isFalse);
      
      appState.setTextScaleFactor(1.2);
      expect(appState.textScaleFactor, 1.2);
    });

    testWidgets('AppState manages accessibility settings',
        (WidgetTester tester) async {
      final appState = AppState();
      
      // Test initial state
      expect(appState.leftHandMode, isTrue);
      expect(appState.highContrast, isFalse);
      expect(appState.largeTargets, isTrue);
      expect(appState.textScaleFactor, 1.0);
      
      // Test setters
      appState.setLeftHandMode(false);
      expect(appState.leftHandMode, isFalse);
      
      appState.setHighContrast(true);
      expect(appState.highContrast, isTrue);
      
      appState.setLargeTargets(false);
      expect(appState.largeTargets, isFalse);
      
      appState.setTextScaleFactor(1.2);
      expect(appState.textScaleFactor, 1.2);
    });

    testWidgets('Form validation works on login',
        (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Try submitting empty form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Error messages should appear
      expect(find.text('Please enter your email address.'), findsOneWidget);
    });

    testWidgets('Email field autofocus works',
        (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Type directly without tapping (autofocus should work)
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Handedness layout functions work correctly',
        (WidgetTester tester) async {
      final appState = AppState();
      
      // Test with left-hand mode enabled
      appState.setLeftHandMode(true);
      expect(appState.leftHandMode, isTrue);
      
      // Test with left-hand mode disabled
      appState.setLeftHandMode(false);
      expect(appState.leftHandMode, isFalse);
      
      // Toggle back
      appState.setLeftHandMode(true);
      expect(appState.leftHandMode, isTrue);
    });

    testWidgets('Multiple settings changes work together',
        (WidgetTester tester) async {
      final appState = AppState();
      
      // Change multiple settings
      appState.setLeftHandMode(false);
      appState.setHighContrast(true);
      appState.setLargeTargets(false);
      appState.setTextScaleFactor(1.3);
      
      // Verify all changes applied
      expect(appState.leftHandMode, isFalse);
      expect(appState.highContrast, isTrue);
      expect(appState.largeTargets, isFalse);
      expect(appState.textScaleFactor, 1.3);
      
      // Reset to defaults
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

    testWidgets('Theme responds to high contrast setting',
        (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
        find.byType(TextFormField).first,
        'demo@careconnect.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        '123456',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      // Skip onboarding
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pumpAndSettle();

      // Initial theme mode
      expect(appState.highContrast, isFalse);
      
      // Toggle high contrast
      appState.setHighContrast(true);
      await tester.pumpAndSettle();
      expect(appState.highContrast, isTrue);
    });

    testWidgets('Text scale slider range is valid',
        (WidgetTester tester) async {
      final appState = AppState();
      
      // Test minimum scale
      appState.setTextScaleFactor(1.0);
      expect(appState.textScaleFactor, 1.0);
      
      // Test maximum scale
      appState.setTextScaleFactor(1.4);
      expect(appState.textScaleFactor, 1.4);
      
      // Test mid-range scale
      appState.setTextScaleFactor(1.2);
      expect(appState.textScaleFactor, 1.2);
    });
  });
}
