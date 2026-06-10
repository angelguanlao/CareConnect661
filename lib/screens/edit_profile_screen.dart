import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/accessible_button.dart';

/// Screen 8 — Edit profile form.
///
/// Pre-populates fields from the current user, validates on submit, and
/// calls [AppState.updateProfile].  Demonstrates the create/edit form
/// requirement, including loading state and success feedback.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  bool _saving    = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser;
    _nameCtrl  = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    await Future.delayed(const Duration(milliseconds: 500)); // simulate save
    if (!mounted) return;

    context.read<AppState>().updateProfile(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
        );

    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully.'),
        backgroundColor: AppTheme.secondary,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Update your details below.',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: AppTheme.textSecondary)),
                const SizedBox(height: 28),

                // ── Name ─────────────────────────────────────────────────
                Semantics(
                  label: 'Full name text field',
                  textField: true,
                  child: TextFormField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Name cannot be empty.';
                      }
                      if (v.trim().length < 2) {
                        return 'Name must be at least 2 characters.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Email ─────────────────────────────────────────────────
                Semantics(
                  label: 'Email address text field',
                  textField: true,
                  child: TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _save(),
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email cannot be empty.';
                      }
                      if (!v.contains('@') || !v.contains('.')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 32),

                AccessibleButton(
                  label: 'Save Changes',
                  semanticLabel: 'Save profile changes',
                  isLoading: _saving,
                  fullWidth: true,
                  icon: Icons.save_rounded,
                  onPressed: _save,
                ),
                const SizedBox(height: 12),
                AccessibleButton(
                  label: 'Cancel',
                  variant: ButtonVariant.outlined,
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
