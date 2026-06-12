import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_strings.dart';

class AuthDivider extends StatelessWidget {
  final String text;
  const AuthDivider({
    super.key,
    this.text = AppStrings.orLoginViaAr,
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