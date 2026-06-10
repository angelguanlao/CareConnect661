import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/feature_model.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Screen 4 — Features list (searchable, filterable).
///
/// Demonstrates the list-view requirement with:
///   - Real-time search filtering
///   - Category filter chips
///   - Empty state when no results match
class FeaturesListScreen extends StatefulWidget {
  const FeaturesListScreen({super.key});
  @override
  State<FeaturesListScreen> createState() => _FeaturesListScreenState();
}

class _FeaturesListScreenState extends State<FeaturesListScreen> {
  final _searchCtrl = TextEditingController();
  String  _query    = '';
  String? _category;

  static const _cats = ['All', 'Navigation', 'Visual', 'Motor Accessibility'];

  List<FeatureModel> get _results => FeatureData.all.where((f) {
        final q = _query.toLowerCase();
        final matchQ = q.isEmpty ||
            f.title.toLowerCase().contains(q) ||
            f.shortDescription.toLowerCase().contains(q);
        final matchC = _category == null ||
            _category == 'All' ||
            f.category == _category;
        return matchQ && matchC;
      }).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final results  = _results;

    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility Features')),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Semantics(
              label: 'Search features',
              textField: true,
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search features…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isNotEmpty
                      ? Semantics(
                          label: 'Clear search',
                          button: true,
                          excludeSemantics: true,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // ── Category chips ─────────────────────────────────────────────
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _cats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat  = _cats[i];
                final sel  = cat == 'All'
                    ? (_category == null || _category == 'All')
                    : _category == cat;
                return Semantics(
                  selected: sel,
                  label: '$cat filter',
                  button: true,
                  child: FilterChip(
                    label: Text(cat),
                    selected: sel,
                    onSelected: (_) =>
                        setState(() => _category = cat == 'All' ? null : cat),
                    selectedColor: AppTheme.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                        color: sel ? Colors.white : AppTheme.textPrimary),
                  ),
                );
              },
            ),
          ),

          // ── Results list ───────────────────────────────────────────────
          Expanded(
            child: results.isEmpty
                ? _EmptyState(query: _query)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) => _FeatureTile(
                      feature: results[i],
                      enabled: appState.isFeatureEnabled(results[i].id),
                      // push preserves back-button behaviour
                      onTap: () =>
                          context.push('/features/${results[i].id}'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Feature tile ──────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  final FeatureModel feature;
  final bool enabled;
  final VoidCallback onTap;
  const _FeatureTile(
      {required this.feature,
      required this.enabled,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${feature.title}. ${feature.shortDescription}. '
          '${enabled ? "Currently enabled." : "Currently disabled."}',
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ── Icon ──────────────────────────────────────────────────
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: enabled
                        ? AppTheme.primary.withValues(alpha: 0.12)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(feature.icon,
                      color: enabled ? AppTheme.primary : Colors.grey,
                      size: 26),
                ),
                const SizedBox(width: 14),

                // ── Text ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feature.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(feature.shortDescription,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 6),
                      _CategoryBadge(label: feature.category),
                    ],
                  ),
                ),

                // ── Status + chevron ──────────────────────────────────────
                Column(
                  children: [
                    if (enabled)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ON',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(height: 6),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppTheme.textSecondary),
                  ],
                ),
              ],
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded,
                size: 64, color: AppTheme.textSecondary),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'No features in this category.'
                  : 'No results for "$query".',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
