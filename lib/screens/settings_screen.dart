import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../state/accessibility_settings.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';
import '../widgets/accessibility_panel.dart';

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
    
    // Create an adapter that provides AccessibilitySettings interface
    // while delegating to AppState methods
    final accessibilityAdapter = _AccessibilitySettingsAdapter(appState, context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Accessibility Panel ────────────────────────────────────────
          AccessibilityPanel(settings: accessibilityAdapter),
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

/// Adapter class that provides AccessibilitySettings interface
/// while delegating to AppState methods for state management.
class _AccessibilitySettingsAdapter extends AccessibilitySettings {
  final AppState _appState;
  final BuildContext _context;

  _AccessibilitySettingsAdapter(this._appState, this._context);

  @override
  bool get leftHandMode => _appState.leftHandMode;

  @override
  bool get highContrast => _appState.highContrast;

  @override
  bool get largerTouchTargets => _appState.largeTargets;

  // Clamp textScale to AccessibilityPanel's expected range (1.0-1.4)
  @override
  double get textScale {
    final scale = _appState.textScaleFactor;
    return scale.clamp(1.0, 1.4);
  }

  @override
  void toggleLeftHandMode(bool value) {
    _context.read<AppState>().setLeftHandMode(value);
  }

  @override
  void toggleHighContrast(bool value) {
    _context.read<AppState>().setHighContrast(value);
  }

  @override
  void toggleLargerTouchTargets(bool value) {
    _context.read<AppState>().setLargeTargets(value);
  }

  @override
  void setTextScale(double value) {
    _context.read<AppState>().setTextScaleFactor(value);
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
