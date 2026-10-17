import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/patientHome/data/models/doctor_model.dart';
import 'package:project1/features/home/patientHome/data/services/patient_appointment_service.dart';

class MyAppointmentsView extends StatefulWidget {
  const MyAppointmentsView({super.key});

  @override
  State<MyAppointmentsView> createState() => _MyAppointmentsViewState();
}

class _MyAppointmentsViewState extends State<MyAppointmentsView> {
  final _service = PatientAppointmentService();
  late Future<List<AppointmentModel>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _service.myAppointments();
  }

  Future<void> _cancel(AppointmentModel appointment) async {
    try {
      await _service.cancel(appointment.id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إلغاء الموعد.')));
      setState(() => _appointments = _service.myAppointments());
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.data?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message is String ? message : 'تعذر إلغاء الموعد.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('مواعيدي'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: FutureBuilder<List<AppointmentModel>>(
        future: _appointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('تعذر تحميل المواعيد. تحقق من الاتصال وحاول مجدداً.'),
            );
          }
          final appointments = snapshot.data ?? const [];
          if (appointments.isEmpty) {
            return const Center(child: Text('لا توجد مواعيد مسجلة.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final cancellable =
                  appointment.status == 'booked' &&
                  appointment.startsAt.isAfter(DateTime.now());
              return Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    appointment.doctorName,
                    textAlign: TextAlign.right,
                  ),
                  subtitle: Text(
                    '${_formatDate(appointment.startsAt)}'
                    '${appointment.specialty == null ? '' : '\n${appointment.specialty}'}'
                    '\n${_statusLabel(appointment.status)}',
                    textAlign: TextAlign.right,
                  ),
                  isThreeLine: appointment.specialty != null,
                  trailing: cancellable
                      ? IconButton(
                          tooltip: 'إلغاء الموعد',
                          onPressed: () => _confirmCancel(appointment),
                          icon: const Icon(
                            Icons.event_busy_outlined,
                            color: Colors.redAccent,
                          ),
                        )
                      : const Icon(Icons.calendar_month_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmCancel(AppointmentModel appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الموعد'),
        content: const Text('هل تريد إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('رجوع'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إلغاء الموعد'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _cancel(appointment);
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour < 12 ? 'ص' : 'م';
    return '${local.day}/${local.month}/${local.year} - $hour:$minute $period';
  }

  String _statusLabel(String status) => switch (status) {
    'booked' => 'مؤكد',
    'cancelled' => 'ملغى',
    'completed' => 'مكتمل',
    _ => status,
  };
}
