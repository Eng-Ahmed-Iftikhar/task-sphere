import 'package:flutter/material.dart';
import 'package:tasksphere/core/constants/app_constants.dart';

class ProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const ProfileField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppConstants.primaryColor),
      ),
    );
  }
}
