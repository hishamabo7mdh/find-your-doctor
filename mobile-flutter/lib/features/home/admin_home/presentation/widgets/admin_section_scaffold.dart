import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_bottom_bar.dart';

class AdminSectionScaffold extends StatelessWidget {
  const AdminSectionScaffold({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.body,
    this.actions,
  });

  final String title;
  final int currentIndex;
  final Widget body;
  final List<Widget>? actions;

  static const _routes = [
    AppRouter.adminHome,
    AppRouter.adminDoctors,
    AppRouter.adminSchedule,
    AppRouter.adminAppointments,
    AppRouter.adminPatients,
    AppRouter.adminSettings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        actions: actions,
      ),
      body: body,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminBottomBar(
            currentIndex: currentIndex,
            onTap: (index) => context.go(_routes[index]),
          ),
          homeIndicator(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
