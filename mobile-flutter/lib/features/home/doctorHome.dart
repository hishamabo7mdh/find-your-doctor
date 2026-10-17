import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/doctor_home/data/models/doctor_appointment_model.dart';
import 'package:project1/features/home/doctor_home/data/services/doctor_dashboard_service.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({super.key});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final _service = DoctorDashboardService();
  DateTime _selectedDate = DateTime.now();
  late Future<List<DoctorAppointmentModel>> _appointments;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() {
    _appointments = _service.appointmentsFor(_selectedDate);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _selectedDate = date;
      _loadAppointments();
    });
  }

  Future<void> _cancel(DoctorAppointmentModel appointment) async {
    try {
      await _service.cancel(appointment.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إلغاء الموعد وإشعار المريض.')),
      );
      setState(_loadAppointments);
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
        title: const Text('مواعيدي كطبيب'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        actions: [
          IconButton(
            tooltip: 'اختيار التاريخ',
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(_loadAppointments),
        child: FutureBuilder<List<DoctorAppointmentModel>>(
          future: _appointments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  const Center(
                    child: Text(
                      'تعذر تحميل المواعيد. تحقق من الاتصال وحاول مجدداً.',
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(_loadAppointments),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ),
                ],
              );
            }

            final appointments = snapshot.data ?? const [];
            if (appointments.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 140),
                  Center(
                    child: Text(
                      'لا توجد مواعيد بتاريخ ${_formatDate(_selectedDate)}.',
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  color: Colors.white,
                  elevation: 0,
                  child: ListTile(
                    title: Text(
                      appointment.patientName,
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                      '${_formatTime(appointment.startsAt)}'
                      '${appointment.patientPhone == null ? '' : '\n${appointment.patientPhone}'}'
                      '\n${_statusLabel(appointment.status)}',
                      textAlign: TextAlign.right,
                    ),
                    isThreeLine: appointment.patientPhone != null,
                    trailing:
                        appointment.status == 'booked' &&
                            appointment.startsAt.isAfter(DateTime.now())
                        ? IconButton(
                            tooltip: 'إلغاء الموعد',
                            onPressed: () => _cancel(appointment),
                            icon: const Icon(
                              Icons.event_busy_outlined,
                              color: Colors.redAccent,
                            ),
                          )
                        : const Icon(Icons.calendar_today_outlined),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '${_formatDate(local)} - $hour:$minute ${local.hour < 12 ? 'ص' : 'م'}';
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  String _statusLabel(String status) => switch (status) {
    'booked' => 'مؤكد',
    'cancelled' => 'ملغى',
    'completed' => 'مكتمل',
    'no_show' => 'لم يحضر',
    _ => status,
  };
}
