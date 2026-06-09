import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/accessibility_settings.dart';

class NavigationMenuScreen extends StatelessWidget {
  const NavigationMenuScreen({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final minTileHeight = settings.largerTouchTargets ? 68.0 : 56.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.person_outline),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Alex Martinez',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Caregiver • CM-4521',
                          style: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _MenuTile(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              minHeight: minTileHeight,
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              ),
            ),
            _MenuTile(
              icon: Icons.people_outline,
              title: 'My Patients',
              minHeight: minTileHeight,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.patients),
            ),
            _MenuTile(
              icon: Icons.description_outlined,
              title: 'Forms & Documents',
              minHeight: minTileHeight,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.forms),
            ),
            _MenuTile(
              icon: Icons.event_note_outlined,
              title: 'Review & Approval',
              minHeight: minTileHeight,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.reviewApproval),
            ),
            _MenuTile(
              icon: Icons.warning_amber_outlined,
              title: 'Validation Errors',
              minHeight: minTileHeight,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.errorValidation),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.minHeight,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final double minHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E293B),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          onTap: onTap,
        ),
      ),
    );
  }
}
