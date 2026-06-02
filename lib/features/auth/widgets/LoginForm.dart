import 'package:flutter/material.dart';
import 'package:tasksphere/core/constants/app_constants.dart';
import 'package:tasksphere/core/routes/app_routes.dart';
import 'package:tasksphere/core/widgets/inputs/password_field.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // All good
      Navigator.pushNamed(context, RoutePaths.home);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));
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

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/logo_icon.png", height: 100),
          const SizedBox(height: 16),

          Text(
            "Welcome to Task Sphere",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Login to continue",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),

          const SizedBox(height: 30),

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

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text("Login", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
