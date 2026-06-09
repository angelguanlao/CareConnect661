import 'package:flutter/material.dart';

import 'routes.dart';
import 'state/accessibility_settings.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CareConnectApp());
}

class CareConnectApp extends StatefulWidget {
  const CareConnectApp({super.key});

  @override
  State<CareConnectApp> createState() => _CareConnectAppState();
}

class _CareConnectAppState extends State<CareConnectApp> {
  final AccessibilitySettings _settings = AccessibilitySettings();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settings,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CareConnect661',
          theme: AppTheme.light(highContrast: _settings.highContrast),
          routes: AppRoutes.build(_settings),
          onGenerateRoute: (routeSettings) =>
              AppRoutes.onGenerateRoute(routeSettings, _settings),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(_settings.textScale),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
