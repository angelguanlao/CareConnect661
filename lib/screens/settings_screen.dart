import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';

/// Screen 9 — Settings.
///
/// Groups controls into Accessibility, Account, and About sections.
/// Every interactive control has an explicit semantic label for
/// TalkBack / VoiceOver.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Accessibility ──────────────────────────────────────────────
          const _SectionHeader(label: 'Accessibility'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _SwitchRow(
                  icon: Icons.swap_horiz_rounded,
                  title: 'Left-Hand Mode',
                  subtitle: 'Positions controls on the left edge.',
                  value: appState.leftHandMode,
                  semanticLabel: appState.leftHandMode
                      ? 'Left-hand mode is on'
                      : 'Left-hand mode is off',
                  onChanged: (v) =>
                      context.read<AppState>().setLeftHandMode(v),
                ),
                const Divider(height: 1, indent: 56),
                _SwitchRow(
                  icon: Icons.contrast_rounded,
                  title: 'High Contrast Mode',
                  subtitle: 'Dark theme with ≥7:1 contrast ratios.',
                  value: appState.highContrast,
                  semanticLabel: appState.highContrast
                      ? 'High contrast mode is on'
                      : 'High contrast mode is off',
                  onChanged: (v) =>
                      context.read<AppState>().setHighContrast(v),
                ),
                const Divider(height: 1, indent: 56),
                _SwitchRow(
                  icon: Icons.touch_app_rounded,
                  title: 'Large Touch Targets',
                  subtitle: 'Expands tap areas to 60×60 dp.',
                  value: appState.largeTargets,
                  semanticLabel: appState.largeTargets
                      ? 'Large touch targets are on'
                      : 'Large touch targets are off',
                  onChanged: (v) =>
                      context.read<AppState>().setLargeTargets(v),
                ),
                const Divider(height: 1, indent: 56),
                // Text scale slider
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.text_fields_rounded,
                          color: AppTheme.primary, size: 26),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Text Size',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                Text(
                                  '${appState.textScaleFactor.toStringAsFixed(1)}×',
                                  style: const TextStyle(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Semantics(
                              label:
                                  'Text scale, current value ${appState.textScaleFactor.toStringAsFixed(1)}',
                              slider: true,
                              child: Slider(
                                value: appState.textScaleFactor,
                                min: 0.8,
                                max: 2.0,
                                divisions: 12,
                                onChanged: (v) => context
                                    .read<AppState>()
                                    .setTextScaleFactor(v),
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Small',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary)),
                                Semantics(
                                  label: 'Reset text size to default',
                                  button: true,
                                  child: TextButton(
                                    onPressed: () => context
                                        .read<AppState>()
                                        .setTextScaleFactor(1.0),
                                    child: const Text('Reset'),
                                  ),
                                ),
                                const Text('Large',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Account ────────────────────────────────────────────────────
          const _SectionHeader(label: 'Account'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _NavRow(
                  icon: Icons.person_rounded,
                  title: 'View Profile',
                  onTap: () => context.go(AppRoutes.profile),
                ),
                const Divider(height: 1, indent: 56),
                _NavRow(
                  icon: Icons.edit_rounded,
                  title: 'Edit Profile',
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── About ──────────────────────────────────────────────────────
          const _SectionHeader(label: 'About'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: const [
                _InfoRow(
                    icon: Icons.info_outlined,
                    title: 'App Version',
                    value: '1.0.0'),
                Divider(height: 1, indent: 56),
                _InfoRow(
                    icon: Icons.accessibility_new_rounded,
                    title: 'WCAG Compliance',
                    value: 'AA + 2.5.5'),
                Divider(height: 1, indent: 56),
                _InfoRow(
                    icon: Icons.school_outlined,
                    title: 'Course',
                    value: 'SWEN 661 — Team 9'),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
            letterSpacing: 1.2),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final String semanticLabel;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.semanticLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: SwitchListTile(
        secondary: Icon(icon, color: AppTheme.primary, size: 26),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 13, color: AppTheme.textSecondary)),
        value: value,
        onChanged: onChanged,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _NavRow(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary, size: 26),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppTheme.textSecondary),
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _InfoRow(
      {required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title: $value',
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textSecondary, size: 24),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15)),
        trailing: Text(value,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 14)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
