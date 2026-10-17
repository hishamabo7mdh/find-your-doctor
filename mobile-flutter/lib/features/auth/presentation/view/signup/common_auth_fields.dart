import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/widgets/field_section.dart';

class CommonAuthFields extends StatelessWidget {
  const CommonAuthFields({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;

  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FieldSection(
          title: AppStrings.firstNameAr,
          hint: AppStrings.firstNameHintAr,
          icon: Icons.person_outline,
          controller: firstNameController,
        ),

        SizedBox(height: 11.h),

        FieldSection(
          title: AppStrings.lastNameAr,
          hint: AppStrings.lastNameHintAr,
          icon: Icons.person_outline,
          controller: lastNameController,
        ),

        SizedBox(height: 11.h),

        FieldSection(
          title: AppStrings.emailAr,
          hint: AppStrings.emailHint,
          icon: Icons.email_outlined,
          controller: emailController,
        ),

        SizedBox(height: 11.h),

        FieldSection(
          title: AppStrings.phoneNumberAr,
          hint: AppStrings.phoneHint,
          icon: Icons.phone,
          controller: phoneController,
          textIType: TextInputType.phone,
        ),

        SizedBox(height: 11.h),

        FieldSection(
          title: AppStrings.passwordAr,
          hint: AppStrings.passwordHintAr,
          icon: Icons.lock_clock_outlined,
          controller: passwordController,
          obscureText: obscurePassword,
          condpass: true,
          suffixIcon: IconButton(
            onPressed: onTogglePassword,
            icon: Icon(
              obscurePassword
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),

        SizedBox(height: 11.h),

        FieldSection(
          title: AppStrings.confirmPasswordAr,
          hint: AppStrings.confirmPasswordHintAr,
          icon: Icons.lock_clock_outlined,
          controller: confirmPasswordController,
          obscureText: obscureConfirmPassword,
          condpass: true,
          suffixIcon: IconButton(
            onPressed: onToggleConfirmPassword,
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
          ),
        ),
      ],
    );
  }
}