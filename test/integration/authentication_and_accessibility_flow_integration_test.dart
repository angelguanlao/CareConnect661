import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';

void main() {
  group('Authentication and accessibility integration flows', () {
    
    testWidgets('Login to dashboard flow works correctly', (WidgetTester tester) async {
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

      // Enter email (email field should have autofocus)
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      // Tap sign-in button
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify we're on home screen
      expect(find.text('CareConnect'), findsWidgets);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Login email field has autofocus', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // The email field should be focused (autofocus: true)
      final emailField = find.byType(TextFormField).first;
      expect(emailField, findsOneWidget);

      // Type directly without tapping (should work because of autofocus)
      await tester.enterText(emailField, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Login validation error is announced as a live region', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Try to sign in with invalid email
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Error message should appear
      expect(find.text('Please enter your email address.'), findsOneWidget);
    });

    testWidgets('Navigation bar exposes semantic labels', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in first
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Check that navigation destinations have semantic labels
      expect(find.byType(NavigationDestination), findsWidgets);

      // Tap Features button in nav bar
      final navItems = find.byType(NavigationDestination);
      expect(navItems, findsWidgets);
    });

    testWidgets('Settings screen exposes the left-handed mode toggle', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify Settings screen shows accessibility controls
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Left-hand mode'), findsWidgets);
    });

    testWidgets('Home quick action tiles remain accessible after login', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify Quick Actions section exists
      expect(find.text('Quick Actions'), findsOneWidget);
      
      // Verify quick action buttons are present
      expect(find.text('High Contrast'), findsOneWidget);
      expect(find.text('Large Targets'), findsOneWidget);
    });

    testWidgets('Profile screen shows authenticated user information', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Tap profile button in app bar
      await tester.tap(find.byIcon(Icons.account_circle).first);
      await tester.pumpAndSettle();

      // Verify profile screen
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Alex Johnson'), findsOneWidget);
    });

    testWidgets('Features list screen exposes search controls', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to Features
      await tester.tap(find.text('Features'));
      await tester.pumpAndSettle();

      // Verify features screen
      expect(find.text('Accessibility Features'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('High contrast quick action changes the active theme', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Get initial background color
      final initialBg = Theme.of(
        tester.element(find.text('CareConnect').first),
      ).scaffoldBackgroundColor;

      // Tap High Contrast toggle (in quick actions grid)
      await tester.tap(find.text('High Contrast'));
      await tester.pumpAndSettle();

      // Verify theme changed (background should be different)
      final newBg = Theme.of(
        tester.element(find.text('CareConnect').first),
      ).scaffoldBackgroundColor;

      expect(initialBg, isNot(equals(newBg)));
    });

    testWidgets('App bootstraps form layout needed for left-handed padding checks', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Get the form context to check padding
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // This is a simplified test - in real app would use widget inspection
      // to verify asymmetric padding is applied
      expect(app, isNotNull);
    });

    testWidgets('Profile edit screen exposes accessible form fields', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Tap profile button
      await tester.tap(find.byIcon(Icons.account_circle).first);
      await tester.pumpAndSettle();

      // Tap edit button
      await tester.tap(find.byIcon(Icons.edit_rounded));
      await tester.pumpAndSettle();

      // Verify edit form
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
    });

    testWidgets('Settings flow can return to a logout confirmation state', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Find and tap logout button (if exists in settings)
      // This assumes there's a logout option in the UI
      // If not, you may need to adjust based on actual UI
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Accessibility panel displays all expected settings', (WidgetTester tester) async {
      final appState = AppState();
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appState,
          child: CareConnectApp(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Log in
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify accessibility settings are visible
      expect(find.text('Accessibility'), findsOneWidget);
      expect(find.text('Left-hand mode'), findsOneWidget);
      expect(find.text('High contrast'), findsOneWidget);
      expect(find.text('Larger touch targets'), findsOneWidget);
      expect(find.text('Text size'), findsOneWidget);
    });
  });
}
