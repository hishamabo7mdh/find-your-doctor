import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class AccountSection extends StatelessWidget {
  final String title;
  final String AUSure;
 final VoidCallback onTap;
  const AccountSection({super.key, required this.title, required this.onTap, required this.AUSure});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Text(
              title,
              style: CustomTextStyles.poppinsRegularTextColor14.copyWith(
                color:  AppColors.primaryColor,
              )
          ),

        ),
        SizedBox(width: 4.w),
        Text(
          AUSure,
          style: CustomTextStyles.poppinsRegularTextColor14.copyWith(color: AppColors.black),
        ),



      ],
    );
  }
}
