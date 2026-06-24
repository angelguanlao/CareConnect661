// End-to-end integration test for the CareConnect Flutter app.
//
// Runs the *real* app on a device/emulator (not a mocked widget tree) and drives
// the full primary journey: Login → 3-step Accessibility Onboarding → Home.
//
// Run with:
//   flutter test integration_test/app_test.dart -d <deviceId>
// (see README "Integration & E2E tests" for device setup).

import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CareConnect E2E', () {
    testWidgets('full journey: login → onboarding → home', (tester) async {
      await pumpApp(tester);

      // ── Login screen ────────────────────────────────────────────────
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'demo@careconnect.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123456',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pumpAndSettle();

      // ── Onboarding step 1: handedness ───────────────────────────────
      expect(find.text('Which hand do you mainly use?'), findsOneWidget);
      await tester.tap(find.text('Left hand'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // ── Onboarding step 2: visual ───────────────────────────────────
      expect(find.text('Visual preferences'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle();

      // ── Onboarding step 3: motor ────────────────────────────────────
      expect(find.text('Motor preferences'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
      await tester.pumpAndSettle();

      // ── Home dashboard reached ──────────────────────────────────────
      expect(find.text('Your Accessibility Profile'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('invalid login keeps user on login with an error', (tester) async {
      await pumpApp(tester);

      // Password too short → validator blocks, stays on login.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'demo@careconnect.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Password must be at least 6 characters.'), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget); // still on login
    });
  });
}
