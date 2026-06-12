import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({
    super.key,
    this.text = "أو تسجيل الدخول عبر",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text),
        ),

        const Expanded(
          child: Divider(),
        ),
      ],
    );
  }
}