import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';
import 'package:project1/features/home/admin_home/data/services/admin_management_service.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_section_scaffold.dart';

class AdminDoctorsView extends StatefulWidget {
  const AdminDoctorsView({super.key});

  @override
  State<AdminDoctorsView> createState() => _AdminDoctorsViewState();
}

class _AdminDoctorsViewState extends State<AdminDoctorsView> {
  final _service = AdminManagementService();
  late Future<List<AdminDoctor>> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = _service.doctors();
  }

  Future<void> _setActive(AdminDoctor doctor, bool value) async {
    try {
      await _service.setDoctorActive(doctor.id, value);
      if (!mounted) return;
      setState(() => _doctors = _service.doctors());
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.data?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message is String ? message : 'تعذر تحديث الطبيب.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminSectionScaffold(
      title: 'إدارة الأطباء',
      currentIndex: 1,
      actions: [
        IconButton(
          tooltip: 'إضافة طبيب',
          onPressed: () => context.push(AppRouter.registerDoctor),
          icon: const Icon(Icons.person_add_alt_1_outlined),
        ),
      ],
      body: FutureBuilder<List<AdminDoctor>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _LoadError(
              message: 'تعذر تحميل قائمة الأطباء.',
              onRetry: () => setState(() => _doctors = _service.doctors()),
            );
          }
          final doctors = snapshot.data!;
          if (doctors.isEmpty) {
            return const _EmptyList(message: 'لا يوجد أطباء.');
          }

          return RefreshIndicator(
            onRefresh: () async =>
                setState(() => _doctors = _service.doctors()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return _RecordCard(
                  name: doctor.name.isEmpty
                      ? 'طبيب #${doctor.id}'
                      : doctor.name,
                  subtitle: [
                    if (doctor.specialty?.isNotEmpty == true) doctor.specialty!,
                    if (doctor.phone?.isNotEmpty == true) doctor.phone!,
                    if (doctor.price != null) '${doctor.price} ر.س',
                  ].join(' · '),
                  active: doctor.isActive,
                  onChanged: (value) => _setActive(doctor, value),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.name,
    required this.subtitle,
    required this.active,
    required this.onChanged,
  });

  final String name;
  final String subtitle;
  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor.withValues(alpha: .12),
          child: const Icon(
            Icons.medical_services_outlined,
            color: AppColors.primaryColor,
          ),
        ),
        title: Text(name, textAlign: TextAlign.right),
        subtitle: Text(
          subtitle.isEmpty ? (active ? 'نشط' : 'غير نشط') : subtitle,
          textAlign: TextAlign.right,
        ),
        trailing: Switch(
          value: active,
          activeThumbColor: AppColors.primaryColor,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}
