import 'package:flutter/material.dart';

import 'models/care_models.dart';
import 'screens/confirmation_screen.dart';
import 'screens/error_validation_screen.dart';
import 'screens/home_screen.dart';
import 'screens/forms_screen.dart';
import 'screens/navigation_menu_screen.dart';
import 'screens/patient_detail_screen.dart';
import 'screens/patients_screen.dart';
import 'screens/review_approval_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/visit_detail_screen.dart';
import 'screens/visits_screen.dart';
import 'state/accessibility_settings.dart';

abstract final class AppRoutes {
  static const String home = '/';
  static const String patients = '/patients';
  static const String patientDetail = '/patients/detail';
  static const String visits = '/visits';
  static const String visitDetail = '/visits/detail';
  static const String forms = '/forms';
  static const String settings = '/settings';
  static const String navigationMenu = '/menu';
  static const String reviewApproval = '/review';
  static const String confirmation = '/confirmation';
  static const String errorValidation = '/error';

  static Map<String, WidgetBuilder> build(
      AccessibilitySettings accessibilitySettings) {
    return <String, WidgetBuilder>{
      home: (_) => HomeScreen(settings: accessibilitySettings),
      patients: (_) => PatientsScreen(settings: accessibilitySettings),
      visits: (_) => VisitsScreen(settings: accessibilitySettings),
      forms: (_) => FormsScreen(settings: accessibilitySettings),
      settings: (_) => SettingsScreen(settings: accessibilitySettings),
      navigationMenu: (_) =>
          NavigationMenuScreen(settings: accessibilitySettings),
      reviewApproval: (_) =>
          ReviewApprovalScreen(settings: accessibilitySettings),
      confirmation: (_) => ConfirmationScreen(settings: accessibilitySettings),
      errorValidation: (_) =>
          ErrorValidationScreen(settings: accessibilitySettings),
    };
  }

  static Route<dynamic>? onGenerateRoute(
    RouteSettings routeSettings,
    AccessibilitySettings settings,
  ) {
    switch (routeSettings.name) {
      case patientDetail:
        final arguments = routeSettings.arguments;
        if (arguments is PatientDetailArgs) {
          return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => PatientDetailScreen(
              settings: settings,
              patient: arguments.patient,
            ),
          );
        }
        return null;
      case visitDetail:
        final arguments = routeSettings.arguments;
        if (arguments is VisitDetailArgs) {
          return MaterialPageRoute<dynamic>(
            settings: routeSettings,
            builder: (_) => VisitDetailScreen(
              settings: settings,
              visit: arguments.visit,
            ),
          );
        }
        return null;
      default:
        return null;
    }
  }
}
