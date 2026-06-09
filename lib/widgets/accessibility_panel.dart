import 'package:flutter/material.dart';

import '../state/accessibility_settings.dart';

class AccessibilityPanel extends StatelessWidget {
  const AccessibilityPanel({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minTileHeight = settings.largerTouchTargets ? 76.0 : 64.0;

    return SingleChildScrollView(
      key: const Key('accessibility-panel'),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Accessibility',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Core controls stay within easy thumb reach.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _PanelToggle(
              title: 'Left-hand mode',
              subtitle: 'Anchor menus and actions on the left edge.',
              value: settings.leftHandMode,
              icon: Icons.back_hand_outlined,
              minHeight: minTileHeight,
              onChanged: settings.toggleLeftHandMode,
            ),
            _PanelToggle(
              title: 'High contrast',
              subtitle: 'Increase separation between text and surfaces.',
              value: settings.highContrast,
              icon: Icons.contrast,
              minHeight: minTileHeight,
              onChanged: settings.toggleHighContrast,
            ),
            _PanelToggle(
              title: 'Larger touch targets',
              subtitle: 'Give key actions more room for reliable taps.',
              value: settings.largerTouchTargets,
              icon: Icons.touch_app_outlined,
              minHeight: minTileHeight,
              onChanged: settings.toggleLargerTouchTargets,
            ),
            const SizedBox(height: 12),
            Text(
              'Text size',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Slider(
              value: settings.textScale,
              min: 1.0,
              max: 1.4,
              divisions: 4,
              label: '${(settings.textScale * 100).round()}%',
              onChanged: settings.setTextScale,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelToggle extends StatelessWidget {
  const _PanelToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.minHeight,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final double minHeight;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            value: value,
            onChanged: onChanged,
            secondary: Icon(icon),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      ),
    );
  }
}
