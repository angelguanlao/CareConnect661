import 'package:care_connect661/main.dart';
import 'package:care_connect661/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('onboarding completion reaches home and shell navigation works',
      (tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: CareConnectApp(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

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

    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Started'));
    await tester.pumpAndSettle();

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.widgetWithText(NavigationDestination, 'Home'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Explore accessibility features'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(NavigationDestination, 'Features'));
    await tester.pumpAndSettle();
    expect(find.text('Accessibility Features'), findsOneWidget);

    await tester.tap(find.widgetWithText(NavigationDestination, 'Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsAtLeastNWidgets(1));

    await tester.tap(find.text('High Contrast Mode'));
    await tester.pumpAndSettle();
    expect(appState.highContrast, isTrue);
  });
}
