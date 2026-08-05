import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';
class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.white,
    this.iconBackgroundColor,
    this.titleColor = AppColors.black,
    this.subTitleColor = AppColors.grey,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onTap;

  final Color backgroundColor;
  final Color? iconBackgroundColor;
  final Color titleColor;
  final Color subTitleColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor ??
                    AppColors.primaryColor.withOpacity(.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: CustomTextStyles.poppinsBoldBlack14.copyWith(
                      color: titleColor,
                      fontSize: 18.sp,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    subTitle,
                    style: CustomTextStyles
                        .poppinsRegularTextGreyText14
                        .copyWith(
                      color: subTitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}