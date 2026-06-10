import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';
import 'utils/routes.dart';

void main() {
  // Create AppState once so it can be passed to both the router
  // and the Provider tree without re-creation on rebuilds.
  final appState = AppState();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: CareConnectApp(appState: appState),
    ),
  );
}

class CareConnectApp extends StatefulWidget {
  final AppState appState;
  const CareConnectApp({super.key, required this.appState});

  @override
  State<CareConnectApp> createState() => _CareConnectAppState();
}

class _CareConnectAppState extends State<CareConnectApp> {
  // The router must be created once and held in state — GoRouter should NOT
  // be re-instantiated on every build() call.
  late final _router = buildRouter(widget.appState);

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp.router(
      title: 'CareConnect',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Switch to the high-contrast dark theme based on user preference.
      themeMode: appState.highContrast ? ThemeMode.dark : ThemeMode.light,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      // Apply the user's custom text scale factor globally.
      // Clamped to 0.8–2.0 in the slider; MediaQuery propagates it to all Text.
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(appState.textScaleFactor),
          ),
          child: child!,
        );
      },
    );
  }
}
