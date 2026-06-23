import 'package:care_connect661/screens/edit_profile_screen.dart';
import 'package:care_connect661/screens/feature_detail_screen.dart';
import 'package:care_connect661/screens/features_list_screen.dart';
import 'package:care_connect661/screens/notifications_screen.dart';
import 'package:care_connect661/screens/profile_screen.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Future<AppState> _loggedInState() async {
  final appState = AppState();
  await appState.login('demo@careconnect.com', '123456');
  appState.completeOnboarding(
    leftHand: true,
    highContrast: false,
    largeTargets: true,
    textScale: 1.0,
  );
  return appState;
}

Widget _wrapWithProvider(AppState appState, Widget child) {
  return ChangeNotifierProvider.value(
    value: appState,
    child: MaterialApp(home: child),
  );
}

void main() {
  group('Uncovered screens smoke and behavior', () {
    testWidgets('Feature detail shows not found for unknown id', (tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        _wrapWithProvider(
          appState,
          const FeatureDetailScreen(featureId: 'missing-id'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Feature not found.'), findsOneWidget);
    });

    testWidgets('Feature detail renders valid feature and toggles state',
        (tester) async {
      final appState = await _loggedInState();

      await tester.pumpWidget(
        _wrapWithProvider(
          appState,
          const FeatureDetailScreen(featureId: 'left-nav'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
      expect(find.text('How to use'), findsOneWidget);

      final wasEnabled = appState.isFeatureEnabled('left-nav');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(appState.isFeatureEnabled('left-nav'), isNot(wasEnabled));
    });

    testWidgets('Features list search and filter paths render', (tester) async {
      final appState = await _loggedInState();

      await tester.pumpWidget(
        _wrapWithProvider(appState, const FeaturesListScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Accessibility Features'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'voice');
      await tester.pumpAndSettle();
      expect(find.textContaining('Voice'), findsWidgets);

      await tester.tap(find.widgetWithText(FilterChip, 'Navigation'));
      await tester.pumpAndSettle();
      expect(find.byType(FilterChip), findsWidgets);

      await tester.enterText(find.byType(TextField), 'zzzz-no-match');
      await tester.pumpAndSettle();
      expect(find.textContaining('No results for'), findsOneWidget);
    });

    testWidgets('Notifications screen empty state renders', (tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        _wrapWithProvider(appState, const NotificationsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('No notifications yet.'), findsOneWidget);
    });

    testWidgets('Notifications mark read interactions update app state',
        (tester) async {
      final appState = await _loggedInState();
      expect(appState.unreadCount, greaterThan(0));

      await tester.pumpWidget(
        _wrapWithProvider(appState, const NotificationsScreen()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Mark all read'));
      await tester.pumpAndSettle();
      expect(appState.unreadCount, 0);

      appState.logout();
      await appState.login('demo@careconnect.com', '123456');
      await tester.pump();

      final before = appState.unreadCount;
      await tester.tap(find.text('Accessibility Tip'));
      await tester.pumpAndSettle();
      expect(appState.unreadCount, lessThan(before));
    });

    testWidgets('Profile screen shows loading state when user missing',
        (tester) async {
      final appState = AppState();

      await tester.pumpWidget(_wrapWithProvider(appState, const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Profile screen renders user details and stats', (tester) async {
      final appState = await _loggedInState();

      await tester.pumpWidget(_wrapWithProvider(appState, const ProfileScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Alex Johnson'), findsOneWidget);
      expect(find.textContaining('Member since'), findsOneWidget);
      expect(find.text('Health Information'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('Edit profile validation errors are shown', (tester) async {
      final appState = await _loggedInState();

      await tester.pumpWidget(
        _wrapWithProvider(appState, const EditProfileScreen()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'),
        'A',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'invalid-email',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pumpAndSettle();

      expect(find.text('Name must be at least 2 characters.'), findsOneWidget);
      expect(find.text('Please enter a valid email address.'), findsOneWidget);
    });

    testWidgets('Edit profile can save valid values to app state', (tester) async {
      final appState = await _loggedInState();

      await tester.pumpWidget(
        _wrapWithProvider(appState, const EditProfileScreen()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full name'),
        'Taylor Brooks',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email address'),
        'taylor@example.com',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Changes'));
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      expect(appState.currentUser?.name, 'Taylor Brooks');
      expect(appState.currentUser?.email, 'taylor@example.com');
    });
  });
}
