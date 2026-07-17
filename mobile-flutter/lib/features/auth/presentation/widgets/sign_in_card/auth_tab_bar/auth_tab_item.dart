import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class AuthTabItem extends StatelessWidget {
  final bool isSelected;
  final String title;
  const AuthTabItem({super.key, required this.isSelected, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h,),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: isSelected ? [ BoxShadow( blurRadius: 4, color: AppColors.secondaryColor, ), ]: null
      ),
      child: Text(
        title,
        style:CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
          color: isSelected ? Colors.black : Colors.grey,
        ),

        textAlign: TextAlign.center,
      ),
    );
  }
}
