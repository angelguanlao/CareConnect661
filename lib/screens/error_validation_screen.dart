import 'package:flutter/material.dart';

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
                      'Please resolve all required fields before submission.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ErrorTile(
            message: 'Time out is required.',
            minHeight: minHeight,
          ),
          _ErrorTile(
            message: 'At least one activity must be selected.',
            minHeight: minHeight,
          ),
          _ErrorTile(
            message: 'Patient signature is missing.',
            minHeight: minHeight,
          ),
        ],
      ),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({
    required this.message,
    required this.minHeight,
  });

  final String message;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: ListTile(
          leading: const Icon(Icons.warning_amber_rounded),
          title: Text(message),
        ),
      ),
    );
  }
}
