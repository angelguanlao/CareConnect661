import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/accessibility_settings.dart';

class ReviewApprovalScreen extends StatelessWidget {
  const ReviewApprovalScreen({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final minTileHeight = settings.largerTouchTargets ? 72.0 : 60.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Review & Approval')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Pending Submission',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Daily Care Log • Margaret Chen'),
                  const SizedBox(height: 4),
                  const Text('Visit time: 9:00 AM - 11:00 AM'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Checklist',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: <Widget>[
                _ChecklistItem(
                  label: 'Visit time entered',
                  minHeight: minTileHeight,
                ),
                _ChecklistItem(
                  label: 'Activities selected',
                  minHeight: minTileHeight,
                ),
                _ChecklistItem(
                  label: 'Signature captured',
                  minHeight: minTileHeight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.confirmation),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Approve & Submit'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.errorValidation),
            icon: const Icon(Icons.error_outline),
            label: const Text('Show Validation Errors'),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.label,
    required this.minHeight,
  });

  final String label;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: CheckboxListTile(
        value: true,
        onChanged: (_) {},
        title: Text(label),
      ),
    );
  }
}
