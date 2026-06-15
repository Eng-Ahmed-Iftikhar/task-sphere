import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;
  const TextDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey, thickness: 1)),
      ],
    );
  }
}
