import 'package:go_router/go_router.dart';
import '../state/app_state.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/accessibility_onboarding_screen.dart';
import '../screens/features_list_screen.dart';
import '../screens/feature_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/notifications_screen.dart';
import '../widgets/main_shell.dart';

/// Named route path constants — centralised to avoid string typos.
class AppRoutes {
  AppRoutes._();
  static const login         = '/login';
  static const onboarding    = '/onboarding';
  static const home          = '/home';
  static const features      = '/features';
  static const notifications = '/notifications';
  static const profile       = '/profile';
  static const editProfile   = '/profile/edit';
  static const settings      = '/settings';
}

/// Builds the application [GoRouter].
///
/// [appState] is passed so [GoRouter.refreshListenable] re-evaluates the
/// redirect callback whenever auth/onboarding state changes.
GoRouter buildRouter(AppState appState) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: appState,
    redirect: (context, state) {
      final loc       = state.matchedLocation;
      final loggedIn  = appState.isLoggedIn;
      final onboarded = appState.isOnboarded;

      // Not logged in → force login screen.
      if (!loggedIn) {
        return loc == AppRoutes.login ? null : AppRoutes.login;
      }
      // Logged in but not yet onboarded → force onboarding.
      if (!onboarded) {
        return loc == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }
      // Fully authenticated — redirect away from auth screens.
      if (loc == AppRoutes.login || loc == AppRoutes.onboarding) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const AccessibilityOnboardingScreen(),
      ),
      // ShellRoute wraps all authenticated screens with the persistent
      // bottom navigation bar (MainShell).
      ShellRoute(
        // Pass state.matchedLocation directly so MainShell always has the
        // correct active route, even deep inside a ShellRoute context.
        builder: (context, state, child) => MainShell(
          location: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.features,
            builder: (_, __) => const FeaturesListScreen(),
          ),
          // Feature detail receives featureId as a path parameter.
          // Push (not go) so the back button returns to the list.
          GoRoute(
            path: '/features/:id',
            builder: (_, state) => FeatureDetailScreen(
              featureId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (_, __) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.editProfile,
            builder: (_, __) => const EditProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}
