import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/patientHome/data/models/doctor_model.dart';
import 'package:project1/features/home/patientHome/data/services/patient_appointment_service.dart';

class DoctorDetailsView extends StatefulWidget {
  const DoctorDetailsView({super.key, required this.doctorId});

  final int doctorId;

  @override
  State<DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<DoctorDetailsView> {
  final _service = PatientAppointmentService();
  late Future<DoctorModel> _doctor;
  late Future<List<AppointmentSlot>> _slots;
  int? _bookingSlot;

  @override
  void initState() {
    super.initState();
    _doctor = _service.getDoctor(widget.doctorId);
    _slots = _service.getSlots(widget.doctorId);
  }

  Future<void> _book(AppointmentSlot slot) async {
    setState(() => _bookingSlot = slot.startsAt.millisecondsSinceEpoch);
    try {
      await _service.book(doctorId: widget.doctorId, slot: slot);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تأكيد حجز الموعد بنجاح.')),
      );
      setState(() => _slots = _service.getSlots(widget.doctorId));
    } on DioException catch (error) {
      if (!mounted) return;
      final message = error.response?.data?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message is String ? message : 'تعذر حجز الموعد. حاول مجدداً.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _bookingSlot = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('تفاصيل الطبيب'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: FutureBuilder<DoctorModel>(
        future: _doctor,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('تعذر تحميل تفاصيل الطبيب.'));
          }

          final doctor = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (doctor.specialty != null)
                        Text(doctor.specialty!, textAlign: TextAlign.right),
                      if (doctor.price != null)
                        Text(
                          'السعر: ${doctor.price}',
                          textAlign: TextAlign.right,
                        ),
                      if (doctor.bio?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 12),
                        Text(doctor.bio!, textAlign: TextAlign.right),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'المواعيد المتاحة',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<AppointmentSlot>>(
                future: _slots,
                builder: (context, slotSnapshot) {
                  if (slotSnapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (slotSnapshot.hasError) {
                    return const Text(
                      'تعذر تحميل المواعيد المتاحة. يرجى المحاولة لاحقاً.',
                      textAlign: TextAlign.right,
                    );
                  }

                  final slots = slotSnapshot.data ?? const [];
                  if (slots.isEmpty) {
                    return const Text(
                      'لا توجد مواعيد متاحة خلال الأسبوعين القادمين.',
                      textAlign: TextAlign.right,
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final slot in slots)
                        OutlinedButton(
                          onPressed: _bookingSlot == null
                              ? () => _book(slot)
                              : null,
                          child:
                              _bookingSlot ==
                                  slot.startsAt.millisecondsSinceEpoch
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_formatSlot(slot.startsAt)),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatSlot(DateTime date) {
    final local = date.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour < 12 ? 'ص' : 'م';
    return '${local.day}/${local.month}  $hour:$minute $period';
  }
}
