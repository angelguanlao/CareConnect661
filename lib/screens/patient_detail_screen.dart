import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../state/accessibility_settings.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({
    super.key,
    required this.settings,
    required this.patient,
  });

  final AccessibilitySettings settings;
  final CarePatient patient;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final horizontalPadding = isCompact ? 12.0 : 20.0;
    final verticalPadding = isCompact ? 12.0 : 20.0;
    final cardPadding = isCompact ? 14.0 : 20.0;

    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
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
                  Text(patient.statusLabel),
                  const SizedBox(height: 8),
                  Text(
                    '${patient.age} years old • ${patient.city}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(patient.summary),
                  const SizedBox(height: 12),
                  Text('Next visit: ${patient.nextVisit}'),
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
                  const Text('Care Plan'),
                  const SizedBox(height: 8),
                  const Text(
                      'Personal care, medication support, and check-ins.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
