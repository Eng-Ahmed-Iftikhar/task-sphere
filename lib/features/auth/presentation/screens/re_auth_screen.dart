import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/core/widgets/inputs/password_field.dart';
import 'package:tasksphere/core/widgets/layouts/scaffold_layout.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';

class ReAuthScreen extends ConsumerStatefulWidget {
  const ReAuthScreen({super.key});

  @override
  ConsumerState<ReAuthScreen> createState() => _ReAuthScreenState();
}

class _ReAuthScreenState extends ConsumerState<ReAuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {
      _hasChanges = _passwordController.text.trim().isNotEmpty;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (!AppUtils.isValidPassword(value)) {
      return 'Password must be at least 8 chars, include upper, lower and a number';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final authActions = ref.read(authProvider.notifier);
    final result = await authActions.reAuthenticate(
      password: _passwordController.text,
    );

    setState(() => _isSubmitting = false);
    result.fold(
      (failure) {
        if (failure is FirebaseAuthFailure) {
          final code = failure.code;
          if (code == FirebaseAuthCodes.invalidCredential) {
            final errorMessage = failure.message;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(errorMessage)));
            return;
          }
        }
      },
      (_) {
        if (!mounted) return;
        // Pop back to profile with success flag
        context.pop(true);
      },
    );
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaffoldLayout(
      appBar: AppBar(
        title: const Text('Re-authenticate'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.bodyMedium?.color,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _hasChanges
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FloatingActionButton.extended(
                  onPressed: _isSubmitting ? null : _submit,
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Confirm'),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PasswordField(
                        controller: _passwordController,
                        validator: _validatePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is required to confirm your identity before sensitive changes.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
