import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        color: const Color(0xFF299E95),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        children: [
          Text(
            'لوحة تحكم الإدارة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
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

          Row(
            children: [
              Expanded(
                child: AdminStatCard(
                  value: '$doctorsCount',
                  title: 'إجمالي الأطباء',
                  icon: Icons.people_outline,
                  change: '+12',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AdminStatCard(
                  value: '$appointmentsCount',
                  title: 'مواعيد اليوم',
                  icon: Icons.calendar_month_outlined,
                  change: '+3',
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
                  title: 'قيد الانتظار',
                  icon: Icons.access_time,
                  change: '-2',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AdminStatCard(
                  value: '$successRate%',
                  title: 'نسبة النجاح',
                  icon: Icons.trending_up,
                  change: '+3',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}