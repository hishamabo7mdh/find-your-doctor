import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.buttonText,
    required this.onTap,
    this.gradient = const [
      Color(0xff50D4CE),
      Color(0xff28B8B0),
    ],
  });

  final String title;
  final String subTitle;
  final String date;
  final String buttonText;
  final VoidCallback onTap;
  final List<Color> gradient;

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
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: CustomTextStyles.poppinsBoldBlack14.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              subTitle,
              style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
                color: Colors.white70,
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              date,
              style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
                color: Colors.white,
              ),
            ),

            SizedBox(height: 12.h),

            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}