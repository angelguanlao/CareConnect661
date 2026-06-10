import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../utils/routes.dart';

/// Persistent shell that wraps every authenticated screen.
///
/// Left-hand optimisation: navigation destinations are ordered left-to-right
/// with the highest-frequency destinations placed on the LEFT side of the bar —
/// the natural resting zone for the left thumb without repositioning the grip.
///   0 Home      ← leftmost, always reachable
///   1 Features  ← second most used
///   2 Alerts    ← notification badge visible at-a-glance
///   3 Settings  ← least frequent, rightmost
class MainShell extends StatelessWidget {
  final Widget child;
  final String location; // passed from ShellRoute builder — always accurate

  const MainShell({super.key, required this.child, required this.location});

  int _selectedIndex(String location) {
    if (location.startsWith('/features'))      return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/settings') ||
        location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.home);
      case 1: context.go(AppRoutes.features);
      case 2: context.go(AppRoutes.notifications);
      case 3: context.go(AppRoutes.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState    = context.watch<AppState>();
    final selectedIdx = _selectedIndex(location); // use the passed parameter
    final unread      = appState.unreadCount;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIdx,
        onDestinationSelected: (i) => _navigate(context, i),
        destinations: [
          // ── Home (leftmost = most reachable for the left thumb) ──────
          NavigationDestination(
            icon: Semantics(
              label: 'Home',
              excludeSemantics: true,
              child: const Icon(Icons.home_outlined),
            ),
            selectedIcon: const Icon(Icons.home_rounded),
            label: 'Home',
          ),
          // ── Features ─────────────────────────────────────────────────
          NavigationDestination(
            icon: Semantics(
              label: 'Features',
              excludeSemantics: true,
              child: const Icon(Icons.accessibility_outlined),
            ),
            selectedIcon: const Icon(Icons.accessibility_new_rounded),
            label: 'Features',
          ),
          // ── Notifications (with unread badge) ─────────────────────────
          NavigationDestination(
            icon: Semantics(
              label: unread > 0
                  ? 'Notifications, $unread unread'
                  : 'Notifications',
              excludeSemantics: true,
              child: Badge(
                isLabelVisible: unread > 0,
                label: Text('$unread'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
            selectedIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_rounded),
            ),
            label: 'Alerts',
          ),
          // ── Settings ─────────────────────────────────────────────────
          NavigationDestination(
            icon: Semantics(
              label: 'Settings',
              excludeSemantics: true,
              child: const Icon(Icons.settings_outlined),
            ),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
