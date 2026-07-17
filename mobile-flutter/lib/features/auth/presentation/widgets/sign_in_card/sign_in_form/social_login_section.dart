import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            text: AppStrings.googleStr,
            icon: Icons.g_mobiledata,
          ),
        ),

        SizedBox(width: 10),

        Expanded(
          child: SocialLoginButton(
            text: AppStrings.applestr,
            icon: Icons.apple,
          ),
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 20,
         color: AppColors.black,
      ),
      label: Text(
        text,
        style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
          color: AppColors.black,
        ),
      ),
    );
  }
}