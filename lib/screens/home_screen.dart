import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/feature_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';

/// Screen 3 — Home / Dashboard.
///
/// Left-hand optimisation:
/// - FAB uses [FloatingActionButtonLocation.startFloat] (bottom-left).
/// - Quick-action grid places the primary toggle in the top-LEFT cell.
/// - All touch targets are ≥48 dp via the theme + explicit constraints.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme    = Theme.of(context);
    final user     = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareConnect'),
        actions: [
          Semantics(
            label: 'View profile',
            button: true,
            child: IconButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryContainer,
                child: Text(
                  user?.initials ?? '?',
                  style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
              onPressed: () => context.go(AppRoutes.profile),
              tooltip: 'View profile',
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      // Left-side FAB — within natural left-thumb reach (WCAG 2.5.5 / 2.5.1).
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Semantics(
        label: 'Explore accessibility features',
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () => context.go(AppRoutes.features),
          icon: const Icon(Icons.accessibility_new_rounded),
          label: const Text('Features'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingBanner(name: user?.name ?? 'there'),
              const SizedBox(height: 20),

              Semantics(
                header: true,
                child: Text('Your Accessibility Profile',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              _ProfileSummaryCard(appState: appState),
              const SizedBox(height: 24),

              Semantics(
                header: true,
                child: Text('Quick Actions',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              _QuickActionsGrid(appState: appState),
              const SizedBox(height: 24),

              Semantics(
                header: true,
                child: Text('Tip of the Day',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              const _TipCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Greeting banner ───────────────────────────────────────────────────────────

class _GreetingBanner extends StatelessWidget {
  final String name;
  const _GreetingBanner({required this.name});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final salutation = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$salutation,',
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 4),
          Text(name.split(' ').first,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Your accessibility settings are active.',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Profile summary card ──────────────────────────────────────────────────────

class _ProfileSummaryCard extends StatelessWidget {
  final AppState appState;
  const _ProfileSummaryCard({required this.appState});

  @override
  Widget build(BuildContext context) {
    final total   = FeatureData.all.length;
    final enabled = appState.enabledFeatureCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatPill(value: '$enabled', label: 'Active',    color: AppTheme.primary),
            _StatPill(value: '${total - enabled}', label: 'Available', color: AppTheme.secondary),
            _StatPill(
              value: appState.leftHandMode ? 'Left' : 'Right',
              label: 'Hand Mode',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatPill(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$value $label',
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

// ── Quick actions grid ────────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  final AppState appState;
  const _QuickActionsGrid({required this.appState});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _QuickTile(
          icon: Icons.contrast_rounded,
          label: 'High Contrast',
          active: appState.highContrast,
          onTap: () =>
              context.read<AppState>().setHighContrast(!appState.highContrast),
        ),
        _QuickTile(
          icon: Icons.touch_app_rounded,
          label: 'Large Targets',
          active: appState.largeTargets,
          onTap: () =>
              context.read<AppState>().setLargeTargets(!appState.largeTargets),
        ),
        _QuickTile(
          icon: Icons.swap_horiz_rounded,
          label: appState.leftHandMode ? 'Left Mode ON' : 'Right Mode',
          active: appState.leftHandMode,
          onTap: () =>
              context.read<AppState>().setLeftHandMode(!appState.leftHandMode),
        ),
        _QuickTile(
          icon: Icons.settings_rounded,
          label: 'All Settings',
          active: false,
          onTap: () => context.go(AppRoutes.settings),
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _QuickTile(
      {required this.icon,
      required this.label,
      required this.active,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      toggled: active,
      child: Material(
        color: active
            ? AppTheme.primary
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: active ? 0 : 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon,
                    color: active ? Colors.white : AppTheme.primary,
                    size: 28),
                Text(label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: active ? Colors.white : AppTheme.textPrimary,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tip card ──────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded,
              color: AppTheme.primary, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Left-Hand Reachability',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppTheme.primary)),
                const SizedBox(height: 4),
                Text(
                  'Place your most-used actions within the lower-left 40% of '
                  'the screen — the natural resting zone for the left thumb.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
