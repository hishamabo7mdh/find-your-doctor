import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';

class SignInLogoSection extends StatelessWidget {
  const SignInLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: _decoration(),
      child: Icon(
        Icons.add_circle_outline,
        size: 70,
        color: AppColors.secondaryColor,
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: AppColors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: const Offset(0, 4),
        )
      ]
    ) ;
  }
}
