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
    final forms = sampleForms;

    if (isCompact) {
      final compactContent = _PhoneFormEntryContent(
        settings: settings,
      );

      if (!showAppBar) {
        return compactContent;
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Daily Care Log')),
        body: RefreshIndicator(
          semanticsLabel: 'Refresh daily care log',
          onRefresh: () async {
            await Future<void>.delayed(const Duration(milliseconds: 500));
          },
          child: compactContent,
        ),
      );
    }

    final listContent = forms.isEmpty
        ? ListView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              verticalPadding,
              horizontalPadding,
              verticalPadding,
            ),
            children: const <Widget>[
              _EmptyStateCard(
                title: 'No forms in progress',
                message:
                    'Draft and submitted forms will appear here after your next visit.',
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
            itemCount: forms.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == forms.length) {
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(isCompact ? 14 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Semantics(
                          button: true,
                          label: 'Open draft review and approval screen',
                          child: FilledButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRoutes.reviewApproval),
                            icon: const Icon(Icons.fact_check_outlined),
                            label: const Text('Review & Approve Draft'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Semantics(
                          button: true,
                          label: 'Open form validation errors screen',
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRoutes.errorValidation),
                            icon: const Icon(Icons.error_outline),
                            label: const Text('View Validation Errors'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final form = forms[index];

              return Semantics(
                label:
                    '${form.title}. Progress ${(form.progress * 100).round()} percent.',
                child: Card(
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
                        LinearProgressIndicator(
                          value: form.progress,
                          semanticsLabel: '${form.title} completion',
                          semanticsValue:
                              '${(form.progress * 100).round()} percent',
                        ),
                        const SizedBox(height: 8),
                        Text(form.description),
                      ],
                    ),
                  ),
                ),
              );
            },
          );

    final content = RefreshIndicator(
      semanticsLabel: 'Refresh forms list',
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      },
      child: listContent,
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

class _PhoneFormEntryContent extends StatelessWidget {
  const _PhoneFormEntryContent({required this.settings});

  final AccessibilitySettings settings;

  @override
  Widget build(BuildContext context) {
    final sectionDot = BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      shape: BoxShape.circle,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      children: <Widget>[
        Semantics(
          label: 'Current form patient Margaret Chen. Draft status.',
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Patient: Margaret Chen',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Draft',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _FormStepCard(
          index: 1,
          title: 'Visit Information',
          dotDecoration: sectionDot,
          child: const Column(
            children: <Widget>[
              _ReadonlyField(label: 'Date of Visit', value: 'May 30, 2026'),
              SizedBox(height: 10),
              _ReadonlyField(label: 'Time In', value: '9:00 AM'),
              SizedBox(height: 10),
              _ReadonlyField(label: 'Time Out', value: '11:00 AM'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _FormStepCard(
          index: 2,
          title: 'Activities Performed',
          dotDecoration: sectionDot,
          child: Column(
            children: <Widget>[
              _ActivityTile(
                label: 'Personal Care',
                checked: true,
                minHeight: settings.largerTouchTargets ? 64 : 54,
              ),
              _ActivityTile(
                label: 'Medication Assistance',
                checked: true,
                minHeight: settings.largerTouchTargets ? 64 : 54,
              ),
              _ActivityTile(
                label: 'Meal Preparation',
                checked: false,
                minHeight: settings.largerTouchTargets ? 64 : 54,
              ),
              _ActivityTile(
                label: 'Light Housekeeping',
                checked: false,
                minHeight: settings.largerTouchTargets ? 64 : 54,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _FormStepCard(
          index: 3,
          title: 'Notes',
          dotDecoration: sectionDot,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 110),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: const Text(
              'Patient tolerated visit well. No medication issues noted.',
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          button: true,
          label: 'Save form draft and open review screen',
          child: FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.reviewApproval),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Draft'),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          button: true,
          label: 'Open validation checks',
          child: OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.errorValidation),
            icon: const Icon(Icons.error_outline),
            label: const Text('Check Validation'),
          ),
        ),
      ],
    );
  }
}

class _FormStepCard extends StatelessWidget {
  const _FormStepCard({
    required this.index,
    required this.title,
    required this.dotDecoration,
    required this.child,
  });

  final int index;
  final String title;
  final BoxDecoration dotDecoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 28,
              height: 28,
              decoration: dotDecoration,
              alignment: Alignment.center,
              child: Text(
                '$index',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyField extends StatelessWidget {
  const _ReadonlyField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.label,
    required this.checked,
    required this.minHeight,
  });

  final String label;
  final bool checked;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        checked: checked,
        label: '$label activity',
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Card(
            margin: EdgeInsets.zero,
            child: CheckboxListTile(
              dense: true,
              value: checked,
              onChanged: (_) {},
              title: Text(label),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      ),
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
              const Icon(Icons.assignment_late_outlined, size: 32),
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
