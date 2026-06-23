import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/accessible_button.dart';

/// Screen 1 — Authentication / Login.
///
/// Accessibility implementation:
/// - All form fields carry [Semantics] labels for TalkBack / VoiceOver.
/// - Error container is a live region so screen readers announce errors.
/// - The sign-in button uses [AccessibleButton] which enforces ≥48 dp height.
/// - Password toggle button has an explicit label ("Show/Hide password").
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  bool  _obscurePass   = true;
  bool  _isLoading     = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMsg = null; });

    final ok = await context.read<AppState>().login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    if (!mounted) return;
    if (!ok) {
      setState(() {
        _isLoading = false;
        _errorMsg  = 'Incorrect email or password. Please try again.';
      });
    }
    // On success the GoRouter redirect navigates automatically.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // ── Brand header ──────────────────────────────────────────
                Semantics(
                  header: true,
                  child: Row(
                    children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.accessibility_new_rounded,
                          color: Colors.white, size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'CareConnect',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Text('Welcome back',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Sign in to continue',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppTheme.textSecondary)),
                const SizedBox(height: 32),

                // ── Email ─────────────────────────────────────────────────
                Semantics(
                  label: 'Email address text field',
                  textField: true,
                  child: TextFormField(
                    autofocus: true,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      hintText: 'you@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Please enter your email address.';
                      }
                      if (!v.contains('@') || !v.contains('.')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Password ──────────────────────────────────────────────
                Semantics(
                  label: 'Password text field',
                  textField: true,
                  child: TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePass,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'At least 6 characters',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: Semantics(
                        label: _obscurePass
                            ? 'Show password'
                            : 'Hide password',
                        button: true,
                        excludeSemantics: true,
                        child: IconButton(
                          icon: Icon(_obscurePass
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter your password.';
                      }
                      if (v.length < 6) {
                        return 'Password must be at least 6 characters.';
                      }
                      return null;
                    },
                  ),
                ),

                // ── Error message (live region) ────────────────────────────
                if (_errorMsg != null) ...[
                  const SizedBox(height: 12),
                  Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: theme.colorScheme.error.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: theme.colorScheme.error, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(_errorMsg!,
                                style: TextStyle(
                                    color: theme.colorScheme.error)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // ── Sign in button ─────────────────────────────────────────
                AccessibleButton(
                  label: 'Sign In',
                  semanticLabel: 'Sign in to CareConnect',
                  isLoading: _isLoading,
                  fullWidth: true,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),

                // ── Sign up button ─────────────────────────────────────────
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: AppTheme.primary,
                      width: 2,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign-up feature coming soon! For now, use any email + password ≥ 6 characters to demo the app.'),
                        backgroundColor: AppTheme.secondary,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  },
                  child: Text(
                    'Create Account',
                    style: theme.textTheme.labelLarge
                        ?.copyWith(color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    'Demo: any email + password ≥ 6 characters',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
