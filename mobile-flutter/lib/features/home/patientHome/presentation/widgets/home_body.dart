import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_action_card.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_button_bar.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/upcoming_appointments_section.dart';

import 'home_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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

                SizedBox(height: 32.h),
                HomeActionCard(
                  title: 'ابحث عن دكتور',
                  subTitle: 'Find Doctor',
                  icon: Icons.search,
                  onTap: () => context.push(AppRouter.doctorSearch),
                ),

                SizedBox(height: 20.h),

                HomeActionCard(
                  title: 'أطبائي',
                  subTitle: 'My Doctors',
                  icon: Icons.medical_services_outlined,
                  onTap: () => context.push(AppRouter.doctorSearch),
                ),

                // SizedBox(height: 20.h),

                // const DoctorCard(),
                SizedBox(height: 20.h),

                UpcomingAppointmentCard(
                  title: 'المواعيد القادمة',
                  subTitle: 'لديك موعد جديد',
                  date: 'غداً - 10:00 صباحاً',
                  buttonText: 'عرض التفاصيل',
                  onTap: () => context.push(AppRouter.appointments),
                ),
                SizedBox(height: 20.h),
                homeIndicator(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            context.push(AppRouter.appointments);
          } else if (index == 2) {
            context.push(AppRouter.doctorSearch);
          } else if (index == 3) {
            context.push(AppRouter.profile);
          }
        },
      ),
    );
  }
}
