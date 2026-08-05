import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.doctorName,
    required this.speciality,
    required this.time,
    required this.onPressed,
  });

  final String doctorName;
  final String speciality;
  final String time;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'موعدك القادم',
            style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
              color: AppColors.white.withOpacity(.9),
            ),
          ),

          SizedBox(height: 18.h),

          Row(
            children: [
              Container(
                width: 54.w,
                height: 54.w,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryColor,
                  size: 28.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      doctorName,
                      style: CustomTextStyles.poppinsBoldBlack14.copyWith(
                        color: AppColors.white,
                        fontSize: 18.sp,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      speciality,
                      style: CustomTextStyles.poppinsRegularTextGreyText14
                          .copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'عرض التفاصيل',
                    style: CustomTextStyles.poppinsBoldBlack14.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              Icon(
                Icons.access_time,
                color: AppColors.white,
                size: 20.sp,
              ),

              SizedBox(width: 6.w),

              Text(
                time,
                style: CustomTextStyles.poppinsBoldBlack14.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}