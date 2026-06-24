import 'package:care_connect661/models/accessibility_option.dart';
import 'package:care_connect661/models/notification_model.dart';
import 'package:care_connect661/models/user_model.dart';
import 'package:care_connect661/state/accessibility_settings.dart';
import 'package:care_connect661/utils/handedness_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Accessibility models and settings', () {
    test('AccessibilityOption copyWith preserves immutable fields', () {
      const option = AccessibilityOption(
        title: 'High contrast',
        description: 'Improves readability',
        icon: Icons.contrast,
        enabled: false,
      );

      final updated = option.copyWith(enabled: true);

      expect(updated.title, option.title);
      expect(updated.description, option.description);
      expect(updated.icon, option.icon);
      expect(updated.enabled, isTrue);
      expect(option.enabled, isFalse);
    });

    test('NotificationModel copyWith toggles read status', () {
      final note = NotificationModel(
        id: 'n1',
        title: 'Tip',
        body: 'Try left hand mode',
        timestamp: DateTime(2026, 1, 1),
      );

      final read = note.copyWith(isRead: true);

      expect(read.id, note.id);
      expect(read.title, note.title);
      expect(read.body, note.body);
      expect(read.timestamp, note.timestamp);
      expect(read.isRead, isTrue);
      expect(note.isRead, isFalse);
    });

    test('UserModel initials for multi-part name', () {
      final user = UserModel(
        id: 'u1',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        joinDate: DateTime(2024, 1, 1),
      );

      expect(user.initials, 'AJ');
    });

    test('UserModel initials for single name', () {
      final user = UserModel(
        id: 'u2',
        name: 'alex',
        email: 'alex@example.com',
        joinDate: DateTime(2024, 1, 1),
      );

      expect(user.initials, 'A');
    });

    test('UserModel initials fallback for empty name', () {
      final user = UserModel(
        id: 'u3',
        name: '',
        email: 'alex@example.com',
        joinDate: DateTime(2024, 1, 1),
      );

      expect(user.initials, '?');
    });

    test('UserModel copyWith updates selected fields only', () {
      final user = UserModel(
        id: 'u4',
        name: 'Alex Johnson',
        email: 'alex@example.com',
        joinDate: DateTime(2024, 1, 1),
        bloodGroup: 'B+',
        allergies: 'Peanuts',
      );

      final updated = user.copyWith(name: 'Sam Lee', email: 'sam@example.com');

      expect(updated.id, user.id);
      expect(updated.joinDate, user.joinDate);
      expect(updated.name, 'Sam Lee');
      expect(updated.email, 'sam@example.com');
      expect(updated.bloodGroup, 'B+');
      expect(updated.allergies, 'Peanuts');
    });

    test('AccessibilitySettings defaults and options map to state', () {
      final settings = AccessibilitySettings();

      expect(settings.leftHandMode, isTrue);
      expect(settings.highContrast, isTrue);
      expect(settings.largerTouchTargets, isTrue);
      expect(settings.textScale, 1.1);
      expect(settings.options.length, 3);

      expect(settings.options[0].title, 'Left-hand mode');
      expect(settings.options[0].enabled, isTrue);
      expect(settings.options[1].title, 'High contrast');
      expect(settings.options[1].enabled, isTrue);
      expect(settings.options[2].title, 'Larger touch targets');
      expect(settings.options[2].enabled, isTrue);
    });

    test('AccessibilitySettings toggles notify listeners on change', () {
      final settings = AccessibilitySettings();
      var notifyCount = 0;
      settings.addListener(() {
        notifyCount++;
      });

      settings.toggleLeftHandMode(false);
      settings.toggleHighContrast(false);
      settings.toggleLargerTouchTargets(false);

      expect(settings.leftHandMode, isFalse);
      expect(settings.highContrast, isFalse);
      expect(settings.largerTouchTargets, isFalse);
      expect(notifyCount, 3);
    });

    test('AccessibilitySettings does not notify when value unchanged', () {
      final settings = AccessibilitySettings();
      var notifyCount = 0;
      settings.addListener(() {
        notifyCount++;
      });

      settings.toggleLeftHandMode(true);
      settings.toggleHighContrast(true);
      settings.toggleLargerTouchTargets(true);

      expect(notifyCount, 0);
    });

    test('AccessibilitySettings text scale is clamped and notifies once', () {
      final settings = AccessibilitySettings();
      var notifyCount = 0;
      settings.addListener(() {
        notifyCount++;
      });

      settings.setTextScale(2.0);
      expect(settings.textScale, 1.4);

      settings.setTextScale(0.5);
      expect(settings.textScale, 1.0);

      final before = notifyCount;
      settings.setTextScale(1.0);
      expect(notifyCount, before);
    });

    test('HandednessLayout row alignment and padding branches', () {
      expect(HandednessLayout.rowAlignment(true), MainAxisAlignment.start);
      expect(HandednessLayout.rowAlignment(false), MainAxisAlignment.end);

      final left = HandednessLayout.asymmetricPadding(
        leftHandMode: true,
        outerPadding: 12,
        thumbPadding: 20,
      );
      final right = HandednessLayout.asymmetricPadding(
        leftHandMode: false,
        outerPadding: 12,
        thumbPadding: 20,
      );

      expect(left.left, 20);
      expect(left.right, 12);
      expect(right.left, 12);
      expect(right.right, 20);
    });

    test('HandednessLayout comfort zone and reachability right hand', () {
      expect(HandednessLayout.isInComfortZone(0.2, leftHandMode: false), isFalse);
      expect(HandednessLayout.isInComfortZone(0.8, leftHandMode: false), isTrue);

      expect(
        HandednessLayout.zoneFor(0.95, leftHandMode: false),
        ReachabilityZone.easy,
      );
      expect(
        HandednessLayout.zoneFor(0.1, leftHandMode: false),
        ReachabilityZone.avoid,
      );
    });
  });
}
