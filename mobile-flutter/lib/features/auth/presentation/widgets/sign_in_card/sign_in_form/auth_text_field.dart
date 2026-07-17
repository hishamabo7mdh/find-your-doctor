import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.hintText,
    this.controller,
    required this.obscureText,
    this.suffixIcon,
    this.keyboardType,
    this.prefixIcon,


  }) ;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      style: CustomTextStyles.poppinsRegularTextColor14,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: CustomTextStyles.poppinsRegularTextGreyText14,
        
        filled: true,
        fillColor: Colors.grey.shade100,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        
        contentPadding:
          EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
        enabledBorder: outlineInputBorder(),
        focusedBorder: outlineInputBorderFocuse(),
        border: outlineInputBorder()
      ),
    );
  }

  OutlineInputBorder  outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(
        color: AppColors.borderColor,
      )
    );
  }
  OutlineInputBorder  outlineInputBorderFocuse() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: AppColors.secondaryColor,
        )
    );
  }
}
