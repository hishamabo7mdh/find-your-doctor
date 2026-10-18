import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/choose_specialty/data/models/doctor_model.dart';
import 'package:project1/features/choose_specialty/data/services/doctor_catalog_service.dart';
import 'package:project1/features/choose_specialty/presentation/widgets/doctor_tile.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key, this.specialtyId, this.specialtyName});

  final int? specialtyId;
  final String? specialtyName;

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  final _service = DoctorCatalogService();
  final _searchController = TextEditingController();
  Timer? _searchTimer;
  late Future<List<DoctorModel>> _doctors;

  @override
  void initState() {
    super.initState();
    _doctors = _loadDoctors();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<DoctorModel>> _loadDoctors() => _service.findDoctors(
    specialtyId: widget.specialtyId,
    query: _searchController.text,
  );

  void _search(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _doctors = _loadDoctors());
    });
  }

  void _retry() => setState(() => _doctors = _loadDoctors());

  String _errorMessage(Object? error) {
    if (error is DioException) {
      final message = error.response?.data?['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return 'تعذر تحميل الأطباء. تحقق من الاتصال وحاول مجددًا.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Doctors'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              textInputAction: TextInputAction.search,
              onChanged: _search,
              onSubmitted: (value) {
                _searchTimer?.cancel();
                setState(() => _doctors = _loadDoctors());
              },
              decoration: InputDecoration(
                hintText: 'ابحث باسم الطبيب',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (widget.specialtyName?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Chip(
                  avatar: const Icon(
                    Icons.medical_services_outlined,
                    size: 18,
                    color: AppColors.primaryColor,
                  ),
                  label: Text(widget.specialtyName!),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                ),
              ),
            ),
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
                    onRetry: _retry,
                  );
                }

                final doctors = snapshot.data!;
                if (doctors.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد أطباء مطابقون لهذا البحث.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _retry(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return DoctorTile(
                        doctor: doctor,
                        onTap: () =>
                            context.push('${AppRouter.doctors}/${doctor.id}'),
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

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      ),
    );
  }
}
