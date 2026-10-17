import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/home/admin_home/data/models/admin_dashboard_stats.dart';
import 'package:project1/features/home/admin_home/data/services/admin_dashboard_service.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_bottom_bar.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_stats_grid.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/fast_procedures_widget.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_header.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final _service = AdminDashboardService();
  late Future<AdminDashboardStats> _stats;

  @override
  void initState() {
    super.initState();
    _stats = _service.getStats();
  }

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

                FutureBuilder<AdminDashboardStats>(
                  future: _stats,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 210,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Column(
                        children: [
                          const Text(
                            'تعذر تحميل إحصائيات النظام.',
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _stats = _service.getStats());
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      );
                    }

                    final stats = snapshot.data!;
                    return AdminStatsGrid(
                      doctorsCount: stats.doctorsCount,
                      appointmentsCount: stats.upcomingAppointments,
                      pendingDoctorsCount: stats.inactiveDoctors,
                      successRate: stats.successRate,
                    );
                  },
                ),
                SizedBox(height: 22.h),
                FastProcedures(),
                SizedBox(height: 22.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminBottomBar(
            currentIndex: 0,
            onTap: (index) => context.go(
              [
                AppRouter.adminHome,
                AppRouter.adminDoctors,
                AppRouter.adminSchedule,
                AppRouter.adminAppointments,
                AppRouter.adminPatients,
                AppRouter.adminSettings,
              ][index],
            ),
          ),
          homeIndicator(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
