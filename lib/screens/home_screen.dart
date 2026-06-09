import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../routes.dart';
import 'forms_screen.dart';
import 'patients_screen.dart';
import 'visits_screen.dart';
import '../state/accessibility_settings.dart';
import '../utils/handedness_layout.dart';
import '../widgets/accessibility_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  void _openAccessibilitySheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: AccessibilityPanel(settings: settings),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return _PhoneShell(settings: settings);
            }

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  tooltip: 'Accessibility settings',
                  onPressed: () => _openAccessibilitySheet(context),
                  icon: const Icon(Icons.tune),
                ),
                title: const Text('CareConnect'),
              ),
              body: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      width: HandednessLayout.navigationRailWidth,
                      child: AccessibilityPanel(settings: settings),
                    ),
                    Expanded(
                      child: _HomeContent(
                        settings: settings,
                        compactLayout: false,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.settings,
    required this.compactLayout,
    this.bottomInset = 0,
  });

  final AccessibilitySettings settings;
  final bool compactLayout;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    if (compactLayout) {
      return _PhoneHomeContent(
        settings: settings,
        bottomInset: bottomInset,
      );
    }

    final theme = Theme.of(context);
    final alignment = HandednessLayout.contentAlignment(settings.leftHandMode);
    final buttonAlignment =
        HandednessLayout.quickActionAlignment(settings.leftHandMode);
    final patients = samplePatients;
    final visits = sampleVisits;
    final contentPadding =
        HandednessLayout.contentPadding(settings.leftHandMode);
    final cardSpacing = HandednessLayout.defaultCardSpacing;

    return SingleChildScrollView(
      key: const Key('home-content'),
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Card(
            key: const Key('hero-card'),
            child: Padding(
              padding: EdgeInsets.all(compactLayout ? 18 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Left-hand accessibility',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'A simplified dashboard that keeps the most-used actions, '
                    'safety checks, and support shortcuts close to the left edge.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const <Widget>[
                      _FeatureChip(
                        icon: Icons.pan_tool_alt_outlined,
                        label: 'Thumb-friendly controls',
                      ),
                      _FeatureChip(
                        icon: Icons.text_fields,
                        label: 'Scalable text',
                      ),
                      _FeatureChip(
                        icon: Icons.visibility_outlined,
                        label: 'High contrast surfaces',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: cardSpacing),
          _SummarySection(
            compactLayout: compactLayout,
            children: <Widget>[
              _SummaryTile(
                label: 'Patients',
                value: '${patients.length}',
                icon: Icons.groups_outlined,
                width: compactLayout ? double.infinity : 160,
              ),
              _SummaryTile(
                label: 'Visits today',
                value: '${visits.length}',
                icon: Icons.event_available_outlined,
                width: compactLayout ? double.infinity : 160,
              ),
              _SummaryTile(
                label: 'Open forms',
                value: '${sampleForms.length}',
                icon: Icons.assignment_outlined,
                width: compactLayout ? double.infinity : 160,
              ),
            ],
          ),
          SizedBox(height: cardSpacing),
          _ActionSection(
            compactLayout: compactLayout,
            children: <Widget>[
              _QuickActionCard(
                icon: Icons.calendar_today_outlined,
                title: 'Appointments',
                description:
                    'Review upcoming visits without leaving the dashboard.',
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.visits),
                width: compactLayout ? double.infinity : 260,
              ),
              _QuickActionCard(
                icon: Icons.medical_services_outlined,
                title: 'Medication',
                description: 'See reminders and dosing notes in one place.',
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.forms),
                width: compactLayout ? double.infinity : 260,
              ),
              _QuickActionCard(
                icon: Icons.favorite_border,
                title: 'Wellness check',
                description: 'Monitor your daily check-in status with one tap.',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.patients),
                width: compactLayout ? double.infinity : 260,
              ),
              _QuickActionCard(
                icon: Icons.support_agent_outlined,
                title: 'Support',
                description:
                    'Contact a coordinator through an easy-to-reach shortcut.',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
                width: compactLayout ? double.infinity : 260,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Priority patients',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _RecordSection(
            compactLayout: compactLayout,
            children: patients
                .map(
                  (patient) => _RecordCard(
                    title: patient.name,
                    subtitle: patient.statusLabel,
                    description: patient.summary,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.patientDetail,
                      arguments: PatientDetailArgs(patient: patient),
                    ),
                    width: compactLayout ? double.infinity : 280,
                  ),
                )
                .toList(growable: false),
          ),
          SizedBox(height: cardSpacing),
          Text(
            'Today\'s visits',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _RecordSection(
            compactLayout: compactLayout,
            children: visits
                .map(
                  (visit) => _RecordCard(
                    title: visit.title,
                    subtitle: visit.statusLabel,
                    description: visit.location,
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.visitDetail,
                      arguments: VisitDetailArgs(visit: visit),
                    ),
                    width: compactLayout ? double.infinity : 280,
                  ),
                )
                .toList(growable: false),
          ),
          SizedBox(height: cardSpacing),
          Align(
            alignment: buttonAlignment,
            child: SizedBox(
              width: compactLayout
                  ? double.infinity
                  : (settings.largerTouchTargets ? 280 : 240),
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.emergency_outlined),
                label: const Text('Emergency assistance'),
              ),
            ),
          ),
          SizedBox(height: bottomInset),
        ],
      ),
    );
  }
}

class _PhoneHomeContent extends StatelessWidget {
  const _PhoneHomeContent({
    required this.settings,
    required this.bottomInset,
  });

  final AccessibilitySettings settings;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final visits = sampleVisits;

    return SingleChildScrollView(
      key: const Key('home-content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Good morning, Alex',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today\'s workflow is left-hand optimized.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  color: Colors.amber.shade50,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.warning_amber_rounded),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('3 pending reviews'),
                              SizedBox(height: 2),
                              Text('Review invoices before 5 PM today.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Today\'s Schedule',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                ...visits.take(2).map(
                      (visit) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.schedule, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(visit.time)),
                                    _StatusChip(status: visit.statusLabel),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  visit.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: <Widget>[
                                    const Icon(Icons.place_outlined, size: 14),
                                    const SizedBox(width: 6),
                                    Expanded(child: Text(visit.location)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 8),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.35,
                  children: <Widget>[
                    _PhoneActionCard(
                      icon: Icons.calendar_today_outlined,
                      title: 'Appointments',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.visits),
                    ),
                    _PhoneActionCard(
                      icon: Icons.medical_services_outlined,
                      title: 'Medication',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.forms),
                    ),
                    _PhoneActionCard(
                      icon: Icons.group_outlined,
                      title: 'Find Patient',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.patients),
                    ),
                    _PhoneActionCard(
                      icon: Icons.support_agent_outlined,
                      title: 'Support',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.settings),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.emergency_outlined),
                    label: const Text('Emergency assistance'),
                  ),
                ),
                SizedBox(height: bottomInset),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneActionCard extends StatelessWidget {
  const _PhoneActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isCompleted = normalized.contains('completed');
    final isActive = normalized.contains('progress');
    final background = isCompleted
        ? Colors.green.shade100
        : isActive
            ? Colors.blue.shade100
            : Colors.grey.shade200;
    final foreground = isCompleted
        ? Colors.green.shade800
        : isActive
            ? Colors.blue.shade800
            : Colors.grey.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}

class _PhoneShell extends StatefulWidget {
  const _PhoneShell({required this.settings});

  final AccessibilitySettings settings;

  @override
  State<_PhoneShell> createState() => _PhoneShellState();
}

class _PhoneShellState extends State<_PhoneShell> {
  int _currentIndex = 0;

  void _openAccessibilitySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: AccessibilityPanel(settings: widget.settings),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      _HomeContent(
        settings: widget.settings,
        compactLayout: true,
        bottomInset: 104,
      ),
      PatientsScreen(settings: widget.settings, showAppBar: false),
      FormsScreen(settings: widget.settings, showAppBar: false),
      VisitsScreen(settings: widget.settings, showAppBar: false),
    ];

    final titles = <String>['CareConnect', 'Patients', 'Forms', 'Alerts'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Open navigation menu',
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.navigationMenu),
          icon: const Icon(Icons.menu),
        ),
        title: Text(titles[_currentIndex]),
        actions: <Widget>[
          IconButton(
            tooltip: 'Accessibility settings',
            onPressed: _openAccessibilitySheet,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          heroTag: 'phone-shell-fab',
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forms),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Forms',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.width,
  });

  final String label;
  final String value;
  final IconData icon;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              const SizedBox(height: 12),
              Text(value, style: theme.textTheme.headlineSmall),
              Text(label, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.compactLayout,
    required this.children,
  });

  final bool compactLayout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (compactLayout) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              ),
            )
            .toList(growable: false),
      );
    }

    return Wrap(
      spacing: HandednessLayout.defaultCardSpacing,
      runSpacing: HandednessLayout.defaultCardSpacing,
      children: children,
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.compactLayout,
    required this.children,
  });

  final bool compactLayout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (compactLayout) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              ),
            )
            .toList(growable: false),
      );
    }

    return Wrap(
      spacing: HandednessLayout.defaultCardSpacing,
      runSpacing: HandednessLayout.defaultCardSpacing,
      children: children,
    );
  }
}

class _RecordSection extends StatelessWidget {
  const _RecordSection({
    required this.compactLayout,
    required this.children,
  });

  final bool compactLayout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (compactLayout) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: child,
              ),
            )
            .toList(growable: false),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: children,
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    required this.width,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.onTap,
    required this.width,
  });

  final String title;
  final String subtitle;
  final String description;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(subtitle),
                const SizedBox(height: 10),
                Text(description),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
