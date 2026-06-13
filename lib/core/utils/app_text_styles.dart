import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

abstract class CustomTextStyles {
  static TextStyle get poppinsExtraBoldTitleText27 => TextStyle(
    fontSize: 27.sp,
    color: AppColors.titleText,
    fontWeight: FontWeight.w800,
    fontFamily: 'Poppins',
    shadows: [
      Shadow(
      color: AppColors.black.withOpacity(0.25),
      blurRadius:6,
      offset: Offset(0, 6),
    ),
  ]
  );

  static TextStyle get poppinsMediumWhite18 => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
    fontFamily: 'Poppins',
  );
  static TextStyle get poppinsRegularTextColor14 => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textColor,
    fontFamily: 'Poppins',
  );

  static TextStyle get poppinsRegularTextGreyText14 => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyText,
     fontFamily: 'Poppins',
  );
  static TextStyle get poppinsBoldBlack14 => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    fontFamily: 'Poppins',
  );

  static TextStyle get PacificoBoldsecondaryColor64 => TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryColor,
    fontFamily: 'Pacifico',
  );
}