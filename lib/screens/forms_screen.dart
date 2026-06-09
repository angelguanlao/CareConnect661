import 'package:flutter/material.dart';

import '../models/care_models.dart';
import '../routes.dart';
import '../state/accessibility_settings.dart';

class FormsScreen extends StatelessWidget {
  const FormsScreen({
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

    final content = ListView.separated(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        verticalPadding,
        horizontalPadding,
        verticalPadding,
      ),
      itemCount: sampleForms.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == sampleForms.length) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(isCompact ? 14 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.reviewApproval),
                    icon: const Icon(Icons.fact_check_outlined),
                    label: const Text('Review & Approve Draft'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.errorValidation),
                    icon: const Icon(Icons.error_outline),
                    label: const Text('View Validation Errors'),
                  ),
                ],
              ),
            ),
          );
        }

        final form = sampleForms[index];

        return Card(
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 14 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  form.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: form.progress),
                const SizedBox(height: 8),
                Text(form.description),
              ],
            ),
          ),
        );
      },
    );

    if (!showAppBar) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Forms')),
      body: content,
    );
  }
}
