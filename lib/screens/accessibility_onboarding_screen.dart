import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/accessible_button.dart';

/// Screen 2 — Accessibility Onboarding (3-step wizard).
///
/// Collects handedness, visual, and motor preferences before the user
/// reaches the home screen.  On finish, calls [AppState.completeOnboarding]
/// which triggers the GoRouter redirect to /home.
class AccessibilityOnboardingScreen extends StatefulWidget {
  const AccessibilityOnboardingScreen({super.key});
  @override
  State<AccessibilityOnboardingScreen> createState() =>
      _AccessibilityOnboardingScreenState();
}

class _AccessibilityOnboardingScreenState
    extends State<AccessibilityOnboardingScreen> {
  final _pageCtrl  = PageController();
  int  _page       = 0;

  // Preferences collected across steps.
  bool   _leftHand     = true;
  bool   _highContrast = false;
  bool   _largeTargets = true;
  double _textScale    = 1.0;

  void _next() {
    if (_page < 2) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _finish() {
    context.read<AppState>().completeOnboarding(
          leftHand: _leftHand,
          highContrast: _highContrast,
          largeTargets: _largeTargets,
          textScale: _textScale,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    label: 'Step ${_page + 1} of 3',
                    child: LinearProgressIndicator(
                      value: (_page + 1) / 3,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Step ${_page + 1} of 3',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppTheme.textSecondary)),
                ],
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  _HandednessStep(
                    leftHand: _leftHand,
                    onChanged: (v) => setState(() => _leftHand = v),
                  ),
                  _VisualStep(
                    highContrast: _highContrast,
                    textScale: _textScale,
                    onContrastChanged: (v) =>
                        setState(() => _highContrast = v),
                    onScaleChanged: (v) => setState(() => _textScale = v),
                  ),
                  _MotorStep(
                    largeTargets: _largeTargets,
                    onChanged: (v) => setState(() => _largeTargets = v),
                  ),
                ],
              ),
            ),

            // ── Navigation buttons ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  if (_page > 0)
                    AccessibleButton(
                      label: 'Back',
                      variant: ButtonVariant.outlined,
                      onPressed: _back,
                    ),
                  const Spacer(),
                  AccessibleButton(
                    label: _page == 2 ? 'Get Started' : 'Next',
                    semanticLabel: _page == 2
                        ? 'Finish setup and go to home screen'
                        : 'Go to next step',
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Handedness ────────────────────────────────────────────────────────

class _HandednessStep extends StatelessWidget {
  final bool leftHand;
  final ValueChanged<bool> onChanged;
  const _HandednessStep({required this.leftHand, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.waving_hand_rounded, size: 48, color: AppTheme.primary),
          const SizedBox(height: 20),
          Text('Which hand do you mainly use?',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('CareConnect will position controls for easier reach.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 32),
          _ChoiceCard(
            label: 'Left hand',
            icon: Icons.back_hand_rounded,
            selected: leftHand,
            onTap: () => onChanged(true),
          ),
          const SizedBox(height: 16),
          _ChoiceCard(
            label: 'Right hand',
            icon: Icons.front_hand_rounded,
            selected: !leftHand,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceCard(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.08)
                : Colors.grey.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: selected ? AppTheme.primary : Colors.transparent,
                width: 2),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: selected ? AppTheme.primary : AppTheme.textSecondary,
                  size: 28),
              const SizedBox(width: 16),
              Text(label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppTheme.primary : AppTheme.textPrimary,
                  )),
              const Spacer(),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    color: AppTheme.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step 2: Visual ────────────────────────────────────────────────────────────

class _VisualStep extends StatelessWidget {
  final bool highContrast;
  final double textScale;
  final ValueChanged<bool> onContrastChanged;
  final ValueChanged<double> onScaleChanged;
  const _VisualStep({
    required this.highContrast,
    required this.textScale,
    required this.onContrastChanged,
    required this.onScaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.visibility_rounded, size: 48, color: AppTheme.primary),
          const SizedBox(height: 20),
          Text('Visual preferences',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Adjust how CareConnect looks.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 28),
          _PrefCard(
            icon: Icons.contrast_rounded,
            title: 'High Contrast Mode',
            subtitle: 'Dark theme with ≥7:1 contrast ratios.',
            trailing: Semantics(
              label: highContrast ? 'High contrast on' : 'High contrast off',
              child: Switch(value: highContrast, onChanged: onContrastChanged),
            ),
          ),
          const SizedBox(height: 16),
          _PrefCard(
            icon: Icons.text_fields_rounded,
            title: 'Text Size',
            subtitle: '${textScale.toStringAsFixed(1)}× scale',
            trailing: SizedBox(
              width: 130,
              child: Semantics(
                label: 'Text scale slider, current value ${textScale.toStringAsFixed(1)}',
                slider: true,
                child: Slider(
                  value: textScale,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  onChanged: onScaleChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 3: Motor ─────────────────────────────────────────────────────────────

class _MotorStep extends StatelessWidget {
  final bool largeTargets;
  final ValueChanged<bool> onChanged;
  const _MotorStep({required this.largeTargets, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.touch_app_rounded, size: 48, color: AppTheme.primary),
          const SizedBox(height: 20),
          Text('Motor preferences',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Reduce the physical effort needed to navigate.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: AppTheme.textSecondary)),
          const SizedBox(height: 28),
          _PrefCard(
            icon: Icons.open_with_rounded,
            title: 'Large Touch Targets',
            subtitle: 'Expands tap areas to 60×60 dp.',
            trailing: Semantics(
              label: largeTargets
                  ? 'Large touch targets on'
                  : 'Large touch targets off',
              child: Switch(value: largeTargets, onChanged: onChanged),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppTheme.primary, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You can change all preferences at any time in Settings.',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppTheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared preference card ────────────────────────────────────────────────────

class _PrefCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  const _PrefCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
