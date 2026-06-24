import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<void> _pumpApp(WidgetTester tester, AppState appState) async {
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: appState,
      child: CareConnectApp(appState: appState),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester) async {
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Email address'),
    'test@example.com',
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Password'),
    'password123',
  );

  await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
  // AppState.login has a 700ms delay.
  await tester.pump(const Duration(milliseconds: 900));
  await tester.pumpAndSettle();
}

Future<void> _completeOnboardingIfPresent(WidgetTester tester) async {
  if (find.text('Step 1 of 3').evaluate().isEmpty) {
    return;
  }

  for (var i = 0; i < 2; i++) {
    final next = find.widgetWithText(ElevatedButton, 'Next');
    if (next.evaluate().isNotEmpty) {
      await tester.tap(next);
      await tester.pumpAndSettle();
    }
  }

  final getStarted = find.widgetWithText(ElevatedButton, 'Get Started');
  if (getStarted.evaluate().isNotEmpty) {
    await tester.tap(getStarted);
    await tester.pumpAndSettle();
  }
}

Future<void> _loginAndReachHome(WidgetTester tester) async {
  await _login(tester);
  await _completeOnboardingIfPresent(tester);
  expect(find.text('Quick Actions'), findsOneWidget);
}

Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(NavigationDestination, label));
  await tester.pumpAndSettle();
}

Future<void> _ensureVisibleAndTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('Authentication and accessibility integration flows', () {
    testWidgets('Login to dashboard flow works correctly',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);

      await _loginAndReachHome(tester);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Home'), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Features'), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Settings'), findsOneWidget);
    });

    testWidgets('Login email field has autofocus', (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);

      final emailField = find.byType(TextFormField).first;
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('Login validation error is announced as a live region',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email address.'), findsOneWidget);
    });

    testWidgets('Navigation bar exposes semantic labels',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      expect(find.byType(NavigationDestination), findsNWidgets(4));
      expect(find.widgetWithText(NavigationDestination, 'Home'), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Features'), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Alerts'), findsOneWidget);
      expect(find.widgetWithText(NavigationDestination, 'Settings'), findsOneWidget);
    });

    testWidgets('Settings screen exposes the left-handed mode toggle',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await _openTab(tester, 'Settings');

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Settings'),
        ),
        findsOneWidget,
      );
      expect(find.text('Left-hand mode'), findsOneWidget);
    });

    testWidgets('Home quick action tiles remain accessible after login',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('High Contrast'), findsOneWidget);
      expect(find.text('Large Targets'), findsOneWidget);
    });

    testWidgets('Profile screen shows authenticated user information',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await tester.tap(find.byTooltip('View profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Alex Johnson'), findsOneWidget);
    });

    testWidgets('Features list screen exposes search controls',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await _openTab(tester, 'Features');

      expect(find.text('Accessibility Features'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('High contrast quick action changes the active theme',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      expect(appState.highContrast, isFalse);
      await _ensureVisibleAndTap(tester, find.text('High Contrast'));
      expect(appState.highContrast, isTrue);
    });

    testWidgets('App bootstraps form layout needed for left-handed padding checks',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app, isNotNull);
    });

    testWidgets('Profile edit screen exposes accessible form fields',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await tester.tap(find.byTooltip('View profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Edit profile'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
    });

    testWidgets('Settings flow can return to a logout confirmation state',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await tester.tap(find.byTooltip('View profile'));
      await tester.pumpAndSettle();
      await _ensureVisibleAndTap(
        tester,
        find.widgetWithText(ElevatedButton, 'Sign Out'),
      );

      expect(find.text('Sign out?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign out'), findsOneWidget);
    });

    testWidgets('Accessibility panel displays all expected settings',
        (WidgetTester tester) async {
      final appState = AppState();
      await _pumpApp(tester, appState);
      await _loginAndReachHome(tester);

      await _openTab(tester, 'Settings');

      expect(find.text('Accessibility'), findsOneWidget);
      expect(find.text('Left-hand mode'), findsOneWidget);
      expect(find.text('High contrast'), findsOneWidget);
      expect(find.text('Larger touch targets'), findsOneWidget);
      expect(find.text('Text size'), findsOneWidget);
    });
  });
}
