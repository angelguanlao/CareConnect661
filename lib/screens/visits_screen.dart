import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../routes.dart';
import '../state/accessibility_settings.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({
    super.key,
    required this.settings,
    this.showAppBar = true,
  });

  final AccessibilitySettings settings;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final horizontalPadding = isCompact ? 12.0 : 20.0;
    final verticalPadding = isCompact ? 12.0 : 20.0;
    final minTileHeight = settings.largerTouchTargets ? 96.0 : 84.0;
    final visits = sampleVisits;

    final listContent = visits.isEmpty
        ? ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            children: const <Widget>[
              _EmptyStateCard(
                title: 'No visits scheduled',
                message:
                    'Upcoming visits will show here once scheduling is complete.',
              ),
            ],
          )
        : ListView.separated(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            itemCount: visits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final visit = visits[index];

              return Semantics(
                button: true,
                label:
                    'Open visit ${visit.title} for ${visit.patientName} details',
                child: Card(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: minTileHeight),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isCompact ? 14 : 20,
                        vertical: isCompact ? 12 : 16,
                      ),
                      title: Text(visit.title),
                      subtitle: Text(
                        '${visit.patientName} • ${visit.time}\n${visit.location}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.visitDetail,
                          arguments: VisitDetailArgs(visit: visit),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );

    final content = RefreshIndicator(
      semanticsLabel: 'Refresh visits list',
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      },
      child: listContent,
    );

    if (!showAppBar) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Visits')),
      body: content,
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$title. $message',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const Icon(Icons.event_busy_outlined, size: 32),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
