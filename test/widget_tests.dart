import 'package:careconnect661/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots into the dashboard and opens visits', (tester) async {
    await tester.pumpWidget(const CareConnectApp());
    await tester.pumpAndSettle();

    expect(find.text('CareConnect'), findsAtLeastNWidgets(1));
    expect(find.text('Emergency assistance'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('home-content')),
      const Offset(0, -600),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appointments'));
    await tester.pumpAndSettle();

    expect(find.text('Visits'), findsOneWidget);
    expect(find.text('Morning Care Visit'), findsOneWidget);

    await tester.tap(find.text('Morning Care Visit'));
    await tester.pumpAndSettle();

    expect(find.text('Morning Care Visit'), findsWidgets);
    expect(find.text('Services'), findsOneWidget);
  });
}
