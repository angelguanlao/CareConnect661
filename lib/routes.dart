import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'state/accessibility_settings.dart';

abstract final class AppRoutes {
  static const String home = '/';

  static Map<String, WidgetBuilder> build(AccessibilitySettings settings) {
    return <String, WidgetBuilder>{
      home: (_) => HomeScreen(),
    };
  }
}
