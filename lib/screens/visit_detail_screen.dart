import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../routes.dart';
import '../state/accessibility_settings.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({
    super.key,
    required this.settings,
    required this.visit,
  });

  final AccessibilitySettings settings;
  final CareVisit visit;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final horizontalPadding = isCompact ? 12.0 : 20.0;
    final verticalPadding = isCompact ? 12.0 : 20.0;
    final cardPadding = isCompact ? 14.0 : 20.0;

    return Scaffold(
      appBar: AppBar(title: Text(visit.title)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          verticalPadding,
          horizontalPadding,
          verticalPadding,
        ),
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(visit.statusLabel),
                  const SizedBox(height: 8),
                  Text('${visit.patientName} • ${visit.time}'),
                  const SizedBox(height: 12),
                  Text(visit.location),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Services'),
                  const SizedBox(height: 12),
                  ...visit.services.map(
                    (service) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.check_circle_outline, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text(service)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.reviewApproval),
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('Continue to Review & Approval'),
          ),
        ],
      ),
    );
  }
}
