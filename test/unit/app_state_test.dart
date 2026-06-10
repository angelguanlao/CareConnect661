import 'package:care_connect661/state/app_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('login success updates auth state and seeds notifications', () async {
    final appState = AppState();

    final ok = await appState.login('demo@careconnect.com', '123456');

    expect(ok, isTrue);
    expect(appState.isLoggedIn, isTrue);
    expect(appState.currentUser, isNotNull);
    expect(appState.notifications.length, 3);
    expect(appState.unreadCount, 2);
  });

  test('completeOnboarding stores accessibility preferences', () {
    final appState = AppState();

    appState.completeOnboarding(
      leftHand: false,
      highContrast: true,
      largeTargets: false,
      textScale: 1.3,
    );

    expect(appState.isOnboarded, isTrue);
    expect(appState.leftHandMode, isFalse);
    expect(appState.highContrast, isTrue);
    expect(appState.largeTargets, isFalse);
    expect(appState.textScaleFactor, 1.3);
  });

  test('feature toggles and notification read operations work', () async {
    final appState = AppState();
    await appState.login('demo@careconnect.com', '123456');

    expect(appState.isFeatureEnabled('voice-input'), isFalse);
    appState.toggleFeature('voice-input');
    expect(appState.isFeatureEnabled('voice-input'), isTrue);

    appState.markRead('1');
    expect(appState.unreadCount, 1);

    appState.markAllRead();
    expect(appState.unreadCount, 0);
  });
}
