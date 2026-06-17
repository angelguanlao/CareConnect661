import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/notification_model.dart';

/// Central ViewModel for CareConnect (MVVM pattern).
///
/// Extends [ChangeNotifier] so that [GoRouter.refreshListenable] re-evaluates
/// redirect logic whenever authentication state changes.
class AppState extends ChangeNotifier {
  // ── Authentication ────────────────────────────────────────────────────────
  bool _isLoggedIn  = false;
  bool _isOnboarded = false;
  UserModel? _currentUser;

  bool get isLoggedIn  => _isLoggedIn;
  bool get isOnboarded => _isOnboarded;
  UserModel? get currentUser => _currentUser;

  /// Simulated login — accepts any non-empty email + password ≥ 6 chars.
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = UserModel(
        id: '1',
        name: 'Alex Johnson',
        email: email,
        joinDate: DateTime(2024, 1, 15),
        bloodGroup: 'B+',
        allergies: 'Penicillin, seafood',
      );
      _isLoggedIn = true;
      _loadSampleNotifications();
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isLoggedIn  = false;
    _isOnboarded = false;
    _currentUser = null;
    _notifications.clear();
    notifyListeners();
  }

  // ── Onboarding ────────────────────────────────────────────────────────────
  void completeOnboarding({
    required bool leftHand,
    required bool highContrast,
    required bool largeTargets,
    required double textScale,
  }) {
    _leftHandMode    = leftHand;
    _highContrast    = highContrast;
    _largeTargets    = largeTargets;
    _textScaleFactor = textScale;
    _isOnboarded     = true;
    notifyListeners();
  }

  // ── Accessibility settings ─────────────────────────────────────────────────
  bool   _highContrast    = false;
  bool   _leftHandMode    = true;   // default: left-hand mode ON
  double _textScaleFactor = 1.0;
  bool   _largeTargets    = true;

  bool   get highContrast    => _highContrast;
  bool   get leftHandMode    => _leftHandMode;
  double get textScaleFactor => _textScaleFactor;
  bool   get largeTargets    => _largeTargets;

  void setHighContrast(bool v)      { _highContrast    = v; notifyListeners(); }
  void setLeftHandMode(bool v)      { _leftHandMode    = v; notifyListeners(); }
  void setTextScaleFactor(double v) { _textScaleFactor = v; notifyListeners(); }
  void setLargeTargets(bool v)      { _largeTargets    = v; notifyListeners(); }

  // ── Feature toggles ────────────────────────────────────────────────────────
  final Set<String> _enabledFeatures = {'left-nav', 'large-targets'};

  Set<String> get enabledFeatures    => Set.unmodifiable(_enabledFeatures);
  int  get enabledFeatureCount       => _enabledFeatures.length;
  bool isFeatureEnabled(String id)   => _enabledFeatures.contains(id);

  void toggleFeature(String id) {
    if (_enabledFeatures.contains(id)) {
      _enabledFeatures.remove(id);
    } else {
      _enabledFeatures.add(id);
    }
    notifyListeners();
  }

  // ── Profile ────────────────────────────────────────────────────────────────
  void updateProfile(String name, String email) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name, email: email);
      notifyListeners();
    }
  }

  // ── Notifications ──────────────────────────────────────────────────────────
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  void markRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void _loadSampleNotifications() {
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Accessibility Tip',
        body: 'Try enabling high-contrast mode for better visibility in bright environments.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      NotificationModel(
        id: '2',
        title: 'New Feature Available',
        body: 'Voice Input Assistance is now available. Tap to learn more.',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationModel(
        id: '3',
        title: 'Weekly Reminder',
        body: 'Review your accessibility preferences to ensure they still meet your needs.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ]);
  }
}
