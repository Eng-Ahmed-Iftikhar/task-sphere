import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/widgets/buttons/social_login_button.dart';
import 'package:tasksphere/core/widgets/dividers/text_divider.dart';
import 'package:tasksphere/features/auth/presentation/providers/auth_providers.dart';
import 'package:tasksphere/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late bool isGoogleLoading = false;

  void handleLogin() async {
    final auth = ref.read(authProvider.notifier);
    setState(() {
      isGoogleLoading = true;
    });
    await auth.loginWithGoogle();

    setState(() {
      isGoogleLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppConstants.primaryColor, AppConstants.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                      spreadRadius: -10,
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    LoginForm(),
                    const SizedBox(height: 10),
                    TextDivider(text: "OR"),
                    const SizedBox(height: 10),
                    SocialLoginButton(
                      text: "Continue with Google",
                      imagePath: "assets/images/google.png",
                      onPressed: handleLogin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
