import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  }); 
  final String text;
  final VoidCallback onPressed;
  
  final double borderRadius = 16;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r)
          ),
        ),
        child: Text(
          text,
          style: CustomTextStyles.poppinsMediumWhite18
        ),
      ),
    );
  }
}
