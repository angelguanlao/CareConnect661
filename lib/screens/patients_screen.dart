import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../routes.dart';
import '../state/accessibility_settings.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({
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

    final content = ListView.separated(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
      itemCount: samplePatients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final patient = samplePatients[index];

        return Card(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minTileHeight),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: isCompact ? 14 : 20,
                vertical: isCompact ? 12 : 16,
              ),
              title: Text(patient.name),
              subtitle: Text(
                '${patient.age} years old • ${patient.city}\n${patient.summary}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.patientDetail,
                  arguments: PatientDetailArgs(patient: patient),
                );
              },
            ),
          ),
        );
      },
    );

    if (!showAppBar) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: content,
    );
  }
}
