import 'package:careconnect661/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menu can navigate to review and confirmation flow',
      (tester) async {
    await tester.pumpWidget(const CareConnectApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    await tester.tap(find.text('Review & Approval'));
    await tester.pumpAndSettle();

    expect(find.text('Review & Approval'), findsOneWidget);
    await tester.tap(find.text('Approve & Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Form Submitted!'), findsOneWidget);
    expect(find.text('Back to Dashboard'), findsOneWidget);
  });

  testWidgets('review flow can open validation errors', (tester) async {
    await tester.pumpWidget(const CareConnectApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review & Approval'));
    await tester.pumpAndSettle();

    expect(find.text('Review & Approval'), findsOneWidget);
    await tester.tap(find.text('Show Validation Errors'));
    await tester.pumpAndSettle();

    expect(find.text('Validation Errors'), findsOneWidget);
    expect(find.textContaining('Unable to submit form'), findsOneWidget);
  });
}
