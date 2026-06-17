import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/routes.dart';

/// Screen 7 — User profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user     = appState.currentUser;
    final theme    = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Semantics(
            label: 'Edit profile',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.push(AppRoutes.editProfile),
              tooltip: 'Edit profile',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Avatar ─────────────────────────────────────────────────
            Semantics(
              label: 'Profile avatar, initials ${user.initials}',
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppTheme.primary,
                child: Text(
                  user.initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(user.name,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.email,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text('Member since ${user.joinDate.year}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 28),

            // ── Health Information ─────────────────────────────────────────
            if (user.bloodGroup != null || user.allergies != null)
              Card(
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Information',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (user.bloodGroup != null) ...[
                        Row(
                          children: [
                            Icon(Icons.bloodtype_rounded,
                                color: AppTheme.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Blood Group',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.textSecondary)),
                                  Text(user.bloodGroup!,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (user.bloodGroup != null && user.allergies != null)
                        const SizedBox(height: 16),
                      if (user.allergies != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_rounded,
                                color: theme.colorScheme.error, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Allergies',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                              color: AppTheme.textSecondary)),
                                  Text(user.allergies!,
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 28),

            // ── Stats ──────────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Stat(
                      value: '${appState.enabledFeatureCount}',
                      label: 'Features\nActive',
                    ),
                    _Stat(
                      value: appState.leftHandMode ? 'Left' : 'Right',
                      label: 'Hand\nMode',
                    ),
                    _Stat(
                      value:
                          '${appState.textScaleFactor.toStringAsFixed(1)}×',
                      label: 'Text\nScale',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Actions ────────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.editProfile),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                label: 'Sign out of CareConnect',
                button: true,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(48, 52),
                  ),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Sign out?'),
                        content: const Text(
                            'You will be returned to the login screen.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[700]),
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sign out'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      context.read<AppState>().logout();
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary)),
          const SizedBox(height: 4),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
