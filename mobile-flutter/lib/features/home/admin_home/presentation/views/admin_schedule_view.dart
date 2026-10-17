import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/features/home/admin_home/data/models/admin_records.dart';
import 'package:project1/features/home/admin_home/data/services/admin_management_service.dart';
import 'package:project1/features/home/admin_home/presentation/widgets/admin_section_scaffold.dart';

class AdminScheduleView extends StatefulWidget {
  const AdminScheduleView({super.key});

  @override
  State<AdminScheduleView> createState() => _AdminScheduleViewState();
}

class _AdminScheduleViewState extends State<AdminScheduleView> {
  final _service = AdminManagementService();
  DateTime _selectedDay = DateTime.now();
  late Future<List<AdminAppointment>> _appointments;

  @override
  void initState() {
    super.initState();
    _appointments = _service.appointments(day: _selectedDay);
  }

  void _selectDay(DateTime date) {
    setState(() {
      _selectedDay = date;
      _appointments = _service.appointments(day: date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminSectionScaffold(
      title: 'الجدول',
      currentIndex: 2,
      actions: [
        TextButton(
          onPressed: () => context.go(AppRouter.adminAppointments),
          child: const Text('كل المواعيد'),
        ),
      ],
      body: Column(
        children: [
          _WeekStrip(selectedDay: _selectedDay, onSelected: _selectDay),
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
                        const Text('تعذر تحميل جدول المواعيد.'),
                        TextButton(
                          onPressed: () => _selectDay(_selectedDay),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                final appointments = [...snapshot.data!]
                  ..sort(
                    (first, second) =>
                        first.startsAt.compareTo(second.startsAt),
                  );
                if (appointments.isEmpty) {
                  return const Center(
                    child: Text('لا توجد مواعيد في هذا اليوم.'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => _selectDay(_selectedDay),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: appointments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      final localTime = appointment.startsAt.toLocal();
                      final hour = localTime.hour % 12 == 0
                          ? 12
                          : localTime.hour % 12;
                      final minute = localTime.minute.toString().padLeft(
                        2,
                        '0',
                      );
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        child: ListTile(
                          leading: Text(
                            '$hour:$minute ${localTime.hour < 12 ? 'ص' : 'م'}',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            appointment.patientName.isEmpty
                                ? 'مريض'
                                : appointment.patientName,
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            'د. ${appointment.doctorName}'
                            '${appointment.specialty == null ? '' : ' · ${appointment.specialty}'}',
                            textAlign: TextAlign.right,
                          ),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () => context.go(AppRouter.adminAppointments),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.selectedDay, required this.onSelected});

  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelected;

  static const _days = ['اث', 'ث', 'أر', 'خ', 'ج', 'س', 'أح'];

  @override
  Widget build(BuildContext context) {
    final start = selectedDay.subtract(
      Duration(days: selectedDay.weekday - DateTime.monday),
    );
    return SizedBox(
      height: 90,
      child: Row(
        children: List.generate(7, (index) {
          final day = start.add(Duration(days: index));
          final selected =
              day.year == selectedDay.year &&
              day.month == selectedDay.month &&
              day.day == selectedDay.day;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(day),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? Colors.teal : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _days[index],
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
