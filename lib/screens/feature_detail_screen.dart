import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/feature_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Screen 5 — Feature detail.
///
/// Receives [featureId] as a go_router path parameter, resolves the feature
/// from the static catalogue, and demonstrates argument passing from list → detail.
class FeatureDetailScreen extends StatelessWidget {
  final String featureId;
  const FeatureDetailScreen({super.key, required this.featureId});

  @override
  Widget build(BuildContext context) {
    // Resolve the feature from the static catalogue using the path parameter.
    FeatureModel? feature;
    try {
      feature = FeatureData.all.firstWhere((f) => f.id == featureId);
    } catch (_) {
      feature = null; // id not found — handled below
    }

    if (feature == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Feature')),
        body: const Center(
          child: Text('Feature not found.',
              style: TextStyle(color: AppTheme.textSecondary)),
        ),
      );
    }

    return _FeatureDetailBody(feature: feature);
  }
}

class _FeatureDetailBody extends StatelessWidget {
  final FeatureModel feature;
  const _FeatureDetailBody({required this.feature});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme    = Theme.of(context);
    final enabled  = appState.isFeatureEnabled(feature.id);

    return Scaffold(
      appBar: AppBar(title: Text(feature.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero section ────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: enabled
                          ? AppTheme.primary.withValues(alpha: 0.12)
                          : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(feature.icon,
                        color: enabled ? AppTheme.primary : Colors.grey,
                        size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryBadge(label: feature.category),
                      const SizedBox(height: 6),
                      Semantics(
                        label: enabled
                            ? 'Feature is enabled'
                            : 'Feature is disabled',
                        child: Text(
                          enabled ? '● Enabled' : '○ Disabled',
                          style: TextStyle(
                            color: enabled ? Colors.green : AppTheme.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Enable / disable button ──────────────────────────────────
              Semantics(
                label: enabled
                    ? 'Disable ${feature.title}'
                    : 'Enable ${feature.title}',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          enabled ? Colors.red[700] : AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(48, 52),
                    ),
                    onPressed: () =>
                        context.read<AppState>().toggleFeature(feature.id),
                    icon: Icon(enabled
                        ? Icons.toggle_off_rounded
                        : Icons.toggle_on_rounded),
                    label:
                        Text(enabled ? 'Disable Feature' : 'Enable Feature'),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── About ───────────────────────────────────────────────────
              Semantics(
                header: true,
                child: Text('About',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(feature.fullDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6, color: AppTheme.textSecondary)),
              const SizedBox(height: 28),

              // ── Steps ────────────────────────────────────────────────────
              Semantics(
                header: true,
                child: Text('How to use',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              ...feature.steps.asMap().entries.map(
                    (e) => _StepRow(number: e.key + 1, text: e.value),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold)),
    );
  }
}

class _StepRow extends StatelessWidget {
  final int number;
  final String text;
  const _StepRow({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        label: 'Step $number: $text',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28, height: 28,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppTheme.primary, shape: BoxShape.circle),
              child: Text('$number',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(text,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                        height: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
