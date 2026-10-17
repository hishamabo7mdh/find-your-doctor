import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';
import 'package:project1/features/home/admin_home/data/services/admin_management_service.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_section_scaffold.dart';

class AdminAppointmentsView extends StatefulWidget {
  const AdminAppointmentsView({super.key});

  @override
  State<AdminAppointmentsView> createState() => _AdminAppointmentsViewState();
}

class _AdminAppointmentsViewState extends State<AdminAppointmentsView> {
  final _service = AdminManagementService();
  DateTime? _selectedDay;
  String? _selectedStatus;
  late Future<List<AdminAppointment>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _load();
  }

  Future<List<AdminAppointment>> _load() =>
      _service.appointments(day: _selectedDay, status: _selectedStatus);

  void _refresh() => setState(() => _appointments = _load());

  Future<void> _chooseDay() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !mounted) return;
    setState(() {
      _selectedDay = date;
      _appointments = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminSectionScaffold(
      title: 'المواعيد',
      currentIndex: 3,
      actions: [
        IconButton(
          tooltip: 'تصفية حسب التاريخ',
          onPressed: _chooseDay,
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ],
      body: Column(
        children: [
          _filters(),
          Expanded(
            child: FutureBuilder<List<AdminAppointment>>(
              future: _appointments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('تعذر تحميل المواعيد.'),
                        TextButton(
                          onPressed: _refresh,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final appointments = snapshot.data!;
                if (appointments.isEmpty) {
                  return const Center(child: Text('لا توجد مواعيد مطابقة.'));
                }
                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: appointments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) =>
                        _AppointmentCard(appointment: appointments[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    const statuses = <String?, String>{
      null: 'الكل',
      'booked': 'مؤكد',
      'completed': 'مكتمل',
      'cancelled': 'ملغى',
      'no_show': 'لم يحضر',
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        children: [
          if (_selectedDay != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('التاريخ: ${_formatDate(_selectedDay!)}'),
                IconButton(
                  tooltip: 'مسح التاريخ',
                  onPressed: () {
                    setState(() {
                      _selectedDay = null;
                      _appointments = _load();
                    });
                  },
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statuses.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: _selectedStatus == entry.key,
                    selectedColor: AppColors.primaryColor.withValues(alpha: .2),
                    onSelected: (_) {
                      setState(() {
                        _selectedStatus = entry.key;
                        _appointments = _load();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment});

  final AdminAppointment appointment;

  @override
  Widget build(BuildContext context) {
    final time = appointment.startsAt.toLocal();
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'ص' : 'م';
    final status = switch (appointment.status) {
      'booked' => 'مؤكد',
      'completed' => 'مكتمل',
      'cancelled' => 'ملغى',
      'no_show' => 'لم يحضر',
      _ => appointment.status,
    };

    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              appointment.patientName.isEmpty
                  ? 'مريض'
                  : appointment.patientName,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              'د. ${appointment.doctorName}'
              '${appointment.specialty == null ? '' : ' · ${appointment.specialty}'}',
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 5),
            Text(
              '${time.day}/${time.month}/${time.year} · $hour:$minute $period · $status',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
