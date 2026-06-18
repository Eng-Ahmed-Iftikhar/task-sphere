import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/error/firebase_auth_failures.dart';
import 'package:tasksphere/core/router/routes.dart';
import 'package:tasksphere/core/utils/app_utils.dart';
import 'package:tasksphere/core/widgets/inputs/password_field.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    final email = value?.trim();
    if (email == null || email.isEmpty) {
      return "Email is required";
    }

    if (!AppUtils.isValidEmail(email)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (!AppUtils.isValidPassword(value)) {
      return "Password must be at least 8 characters, include an uppercase letter, a lowercase letter, and a number";
    }

    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }

    return null;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      // Call register API here using email and password
      final authActions = ref.read(authProvider.notifier);
      setState(() {
        isLoading = true;
      });
      await authActions.register(name: name, email: email, password: password);
      setState(() {
        isLoading = false;
      });
      final auth = ref.read(authProvider);
      final code = auth.asData?.value.authFailure?.code;
      print("auth code $code");
      if (code == FirebaseAuthCodes.emailAlreadyInUse) {
        final errorMessage =
            auth.asData?.value.authFailure?.message ??
            "Email is already in use";
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful")));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,

      child: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo_icon.png", height: 100),
            const SizedBox(height: 16),

            Text(
              "Create an Account",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    "Already have an account?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pushNamed(RouteNames.login);
                    },
                    child: const Text("Sign In"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            TextFormField(
              controller: _nameController,
              validator: _validateName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              validator: _validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 16),

            PasswordField(
              controller: _passwordController,
              validator: _validatePassword,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text("Register", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
