import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/user_session.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_section_scaffold.dart';

class AdminSettingsView extends StatelessWidget {
  const AdminSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = UserSession.currentUser?.fullName ?? '';
    return AdminSectionScaffold(
      title: 'الإعدادات',
      currentIndex: 5,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.white,
            elevation: 0,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              title: Text(userName.isEmpty ? 'حساب الإدارة' : userName),
              subtitle: const Text('مدير النظام'),
            ),
          ),
          const SizedBox(height: 12),
          _SettingsItem(
            icon: Icons.person_outline,
            title: 'الملف الشخصي',
            onTap: () => context.push(AppRouter.profile),
          ),
          _SettingsItem(
            icon: Icons.medical_services_outlined,
            title: 'إدارة الأطباء',
            onTap: () => context.go(AppRouter.adminDoctors),
          ),
          _SettingsItem(
            icon: Icons.people_outline,
            title: 'إدارة المرضى',
            onTap: () => context.go(AppRouter.adminPatients),
          ),
          _SettingsItem(
            icon: Icons.calendar_month_outlined,
            title: 'المواعيد',
            onTap: () => context.go(AppRouter.adminAppointments),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (context.mounted) context.go(AppRouter.signIn);
            },
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryColor),
        title: Text(title, textAlign: TextAlign.right),
        trailing: const Icon(Icons.chevron_left),
        onTap: onTap,
      ),
    );
  }
}
