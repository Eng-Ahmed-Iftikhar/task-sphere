import 'package:flutter/material.dart';
import 'package:tasksphere/core/constants/app_constants.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String label;
  final AutovalidateMode? autovalidateMode;

  const PasswordField({
    super.key,
    required this.controller,
    required this.validator,
    this.autovalidateMode,
    this.label = "Password",
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: widget.label,
        errorMaxLines: 3,
        prefixIcon: Icon(Icons.lock_outline, color: AppConstants.primaryColor),
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
