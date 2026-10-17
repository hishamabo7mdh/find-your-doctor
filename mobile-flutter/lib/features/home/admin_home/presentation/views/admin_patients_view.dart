import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';
import 'package:project1/features/home/admin_home/data/services/admin_management_service.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_section_scaffold.dart';

class AdminPatientsView extends StatefulWidget {
  const AdminPatientsView({super.key});

  @override
  State<AdminPatientsView> createState() => _AdminPatientsViewState();
}

class _AdminPatientsViewState extends State<AdminPatientsView> {
  final _service = AdminManagementService();
  late Future<List<AdminPatient>> _patients;

  @override
  void initState() {
    super.initState();
    _patients = _service.patients();
  }

  Future<void> _setActive(AdminPatient patient, bool value) async {
    try {
      await _service.setPatientActive(patient.id, value);
      if (!mounted) return;
      setState(() => _patients = _service.patients());
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.data?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message is String ? message : 'تعذر تحديث المريض.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminSectionScaffold(
      title: 'المرضى',
      currentIndex: 4,
      body: FutureBuilder<List<AdminPatient>>(
        future: _patients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('تعذر تحميل قائمة المرضى.'),
                  TextButton(
                    onPressed: () =>
                        setState(() => _patients = _service.patients()),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final patients = snapshot.data!;
          if (patients.isEmpty) {
            return const Center(child: Text('لا يوجد مرضى.'));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                setState(() => _patients = _service.patients()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: patients.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryColor.withValues(
                        alpha: .12,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    title: Text(
                      patient.name.isEmpty
                          ? 'مريض #${patient.id}'
                          : patient.name,
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      [
                        patient.phone,
                        patient.email,
                      ].where((value) => value?.isNotEmpty == true).join(' · '),
                      textAlign: TextAlign.right,
                    ),
                    trailing: Switch(
                      value: patient.isActive,
                      activeThumbColor: AppColors.primaryColor,
                      onChanged: (value) => _setActive(patient, value),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
