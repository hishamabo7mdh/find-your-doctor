import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_text_field.dart';

class FieldSection extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType textIType;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool condpass;
  const FieldSection({
    super.key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.controller,
    this.textIType = TextInputType.emailAddress,
    this.suffixIcon,
    this.obscureText = false,
    this.condpass = false,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: CustomTextStyles.poppinsBoldBlack14),
        SizedBox(height: 10.h),
        AuthTextField(
          controller: controller,
          hintText: hint,
          keyboardType: textIType,
          obscureText: obscureText,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}
