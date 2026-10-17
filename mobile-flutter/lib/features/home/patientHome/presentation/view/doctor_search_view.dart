import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/home/patientHome/data/models/doctor_model.dart';
import 'package:project1/features/home/patientHome/data/models/specialty_model.dart';
import 'package:project1/features/home/patientHome/data/services/patient_appointment_service.dart';
import 'dart:async';

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  final _service = PatientAppointmentService();
  final _searchController = TextEditingController();
  late Future<List<DoctorModel>> _doctors;
  late Future<List<SpecialtyModel>> _specialties;
  int? _selectedSpecialtyId;
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _doctors = _service.findDoctors();
    _specialties = _service.getSpecialties();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String value) {
    _searchTimer?.cancel();
    setState(
      () => _doctors = _service.findDoctors(
        query: value,
        specialtyId: _selectedSpecialtyId,
      ),
    );
  }

  void _scheduleSearch(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(
      const Duration(milliseconds: 300),
      () => _search(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('ابحث عن طبيب'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              onChanged: _scheduleSearch,
              decoration: InputDecoration(
                hintText: 'اسم الطبيب',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<SpecialtyModel>>(
              future: _specialties,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(
                        () => _specialties = _service.getSpecialties(),
                      ),
                      child: const Text('تعذر تحميل التخصصات - أعد المحاولة'),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }
                return DropdownButtonFormField<int?>(
                  initialValue: _selectedSpecialtyId,
                  decoration: InputDecoration(
                    labelText: 'التخصص',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('جميع التخصصات'),
                    ),
                    for (final specialty in snapshot.data!)
                      DropdownMenuItem<int?>(
                        value: specialty.id,
                        child: Text(specialty.name),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedSpecialtyId = value;
                      _doctors = _service.findDoctors(
                        query: _searchController.text,
                        specialtyId: value,
                      );
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<DoctorModel>>(
                future: _doctors,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _MessageState(
                      message: _errorMessage(snapshot.error),
                      onRetry: () => _search(_searchController.text),
                    );
                  }

                  final doctors = snapshot.data ?? const [];
                  if (doctors.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد أطباء مطابقون للبحث.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.backgroundColor,
                            child: Icon(
                              Icons.medical_services_outlined,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          title: Text(
                            doctor.name,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            [
                              if (doctor.specialty?.isNotEmpty ?? false)
                                doctor.specialty!,
                              if (doctor.price != null)
                                'السعر: ${doctor.price}',
                            ].join(' • '),
                            textAlign: TextAlign.right,
                          ),
                          trailing: const Icon(Icons.chevron_left),
                          onTap: () => context.push('/doctors/${doctor.id}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _errorMessage(Object? error) {
    if (error is DioException) {
      final message = error.response?.data?['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'تعذر تحميل الأطباء. تحقق من اتصالك وحاول مجدداً.';
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
        ],
      ),
    );
  }
}
