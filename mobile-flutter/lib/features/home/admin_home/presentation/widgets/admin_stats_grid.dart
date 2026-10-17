import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'admin_stat_card.dart';

class AdminStatsGrid extends StatelessWidget {
  final int doctorsCount;
  final int appointmentsCount;
  final int pendingDoctorsCount;
  final int successRate;

  const AdminStatsGrid({
    super.key,
    required this.doctorsCount,
    required this.appointmentsCount,
    required this.pendingDoctorsCount,
    required this.successRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            'لوحة تحكم الإدارة',
            textAlign: TextAlign.center,
            style: CustomTextStyles.poppinsExtraBoldTitleText27.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),

          SizedBox(height: 4.h),

          Text(
            'إحصائيات النظام',
            style: TextStyle(
              color: Colors.white.withOpacity(.85),
              fontSize: 11.sp,
            ),
          ),

          SizedBox(height: 10.h),

          CardsAdministrariveControl(
            doctorsCount: doctorsCount,
            appointmentsCount: appointmentsCount,
            pendingDoctorsCount: pendingDoctorsCount,
            successRate: successRate,
          ),
        ],
      ),
    );
  }
}

class CardsAdministrariveControl extends StatelessWidget {
  const CardsAdministrariveControl({
    super.key,
    required this.doctorsCount,
    required this.appointmentsCount,
    required this.pendingDoctorsCount,
    required this.successRate,
  });

  final int doctorsCount;
  final int appointmentsCount;
  final int pendingDoctorsCount;
  final int successRate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AdminStatCard(
                value: '$doctorsCount',
                title: 'إجمالي الأطباء',
                icon: Icons.people_outline,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: AdminStatCard(
                value: '$appointmentsCount',
                title: 'مواعيد قادمة',
                icon: Icons.calendar_month_outlined,
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Expanded(
              child: AdminStatCard(
                value: '$pendingDoctorsCount',
                title: 'أطباء غير نشطين',
                icon: Icons.access_time,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: AdminStatCard(
                value: '$successRate%',
                title: 'نسبة النجاح',
                icon: Icons.trending_up,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
