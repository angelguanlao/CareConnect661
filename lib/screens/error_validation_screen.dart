import 'package:flutter/material.dart';

import '../routes.dart';
import '../state/accessibility_settings.dart';

class ErrorValidationScreen extends StatelessWidget {
  const ErrorValidationScreen({
    super.key,
    required this.settings,
  });

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final minHeight = settings.largerTouchTargets ? 72.0 : 60.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Validation Errors')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Unable to submit form. Fix the errors below before continuing.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _IssueSection(
            title: 'Visit Information',
            minHeight: minHeight,
            messages: const <String>[
              'Date of visit is required.',
              'Time out must be after time in.',
            ],
          ),
          const SizedBox(height: 12),
          _IssueSection(
            title: 'Activities Performed',
            minHeight: minHeight,
            messages: const <String>[
              'Select at least one completed activity.',
            ],
          ),
          const SizedBox(height: 12),
          _IssueSection(
            title: 'Signature',
            minHeight: minHeight,
            messages: const <String>[
              'Patient signature is missing.',
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.forms),
            icon: const Icon(Icons.edit_note),
            label: const Text('Return to Form'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.reviewApproval),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save as Draft'),
          ),
        ],
      ),
    );
  }
}

class _IssueSection extends StatelessWidget {
  const _IssueSection({
    required this.title,
    required this.minHeight,
    required this.messages,
  });

  final String title;
  final double minHeight;
  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...messages.map(
              (message) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: minHeight),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber_rounded),
                    title: Text(message),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
