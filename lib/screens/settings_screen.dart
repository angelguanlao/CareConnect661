import 'package:flutter/material.dart';

import '../state/accessibility_settings.dart';
import '../widgets/accessibility_panel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final horizontalPadding = isCompact ? 12.0 : 20.0;
    final verticalPadding = isCompact ? 12.0 : 20.0;
    final cardPadding = isCompact ? 14.0 : 20.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding,
          horizontalPadding,
          verticalPadding,
        ),
        children: <Widget>[
          AccessibilityPanel(settings: settings),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Profile'),
                  const SizedBox(height: 8),
                  const Text('Alex Martinez • Caregiver'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
