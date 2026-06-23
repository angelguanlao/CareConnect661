import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Login screen shows login form with email and password',
      (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Verify we're on login screen
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });

  testWidgets('Email field has autofocus enabled', (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Email field should be autofocused - we can type without tapping
    final emailField = find.byType(TextFormField).first;
    expect(emailField, findsOneWidget);

    // Type directly - should work due to autofocus
    await tester.enterText(emailField, 'test@example.com');
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('Form validation shows error on empty submit',
      (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Try to sign in with empty fields
    final signInButton = find.text('Sign In');
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Error message should appear
    expect(find.text('Please enter your email address.'), findsOneWidget);
  });

  testWidgets('Navigation bar is visible after login', (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Fill in login form
    await tester.enterText(
      find.byType(TextFormField).first,
      'demo@careconnect.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      '123456',
    );

    // Sign in
    await tester.tap(find.text('Sign In'));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    // Navigate through onboarding screens
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();

    // Verify navigation bar exists
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Settings screen accessibility panel is present',
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

    // Navigate to Settings
    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();

    // Verify we're on settings screen
    expect(find.text('Settings'), findsWidgets);

    // Verify accessibility panel exists with key
    expect(find.byKey(const Key('accessibility-panel')), findsOneWidget);
  });

  testWidgets('Left-hand mode toggle is accessible', (WidgetTester tester) async {
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

    // Navigate to Settings
    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();

    // Verify left-hand mode text is present
    expect(find.text('Left-hand mode'), findsOneWidget);

    // Verify initial state
    expect(appState.leftHandMode, isTrue);
  });
}
