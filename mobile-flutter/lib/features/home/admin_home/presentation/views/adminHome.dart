import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/auth/data/models/user_model.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';
import 'package:project1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_action_card.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_bottom_bar.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_stats_grid.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_action_card.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_button_bar.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_header.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/upcoming_appointments_section.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                HomeHeader(userName: UserSession.currentUser?.fullName ?? ''),

                SizedBox(height: 20.h),

                AdminStatsGrid(
                  doctorsCount: 248,
                  appointmentsCount: 12,
                  pendingDoctorsCount: 5,
                  successRate: 94,
                ),
                SizedBox(height: 22.h),
                Text(
                  'إجراءات سريعة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: AdminActionCard(
                        title: 'تسجيل دكتور',
                        subtitle: 'Register Doctor',
                        icon: Icons.person_add_alt_1_outlined,
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => const DoctorRegisterPage(),
                          //   ),
                          // );
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AdminActionCard(
                        title: 'إدارة الأطباء',
                        subtitle: 'Manage Doctors',
                        icon: Icons.groups_outlined,
                        onTap: () {
                          // Navigate to doctors
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                Row(
                  children: [
                    Expanded(
                      child: AdminActionCard(
                        title: 'المواعيد',
                        subtitle: 'Appointments',
                        icon: Icons.calendar_month_outlined,
                        onTap: () {
                          // Navigate to appointments
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AdminActionCard(
                        title: 'الإعدادات',
                        subtitle: 'Settings',
                        icon: Icons.settings_outlined,
                        onTap: () {
                          // Navigate to settings
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                homeIndicator(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: 0,
        onTap: (index) {
          // التنقل بين الصفحات
        },
      ),
    );
  }
}
