import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/choose_specialty/data/models/specialty_model.dart';
import 'package:project1/features/choose_specialty/data/services/doctor_catalog_service.dart';
import 'package:project1/features/choose_specialty/presentation/widgets/specialty_grid_widget.dart';

class ChooseSpecialtyView extends StatefulWidget {
  const ChooseSpecialtyView({super.key});

  @override
  State<ChooseSpecialtyView> createState() => _ChooseSpecialtyViewState();
}

class _ChooseSpecialtyViewState extends State<ChooseSpecialtyView> {
  final _service = DoctorCatalogService();
  final _searchController = TextEditingController();
  late Future<List<SpecialtyModel>> _specialties;

  @override
  void initState() {
    super.initState();
    _specialties = _service.getSpecialties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDoctors({int? specialtyId, String? specialtyName}) {
    final location = Uri(
      path: AppRouter.doctors,
      queryParameters: {
        if (specialtyId != null) 'specialty_id': '$specialtyId',
        if (specialtyName != null) 'specialty_name': specialtyName,
      },
    );
    context.push(location.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Choose Specialty'),
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.textColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'اختر التخصص الطبي',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'ابحث عن التخصص المناسب لعرض الأطباء المتاحين.',
                  textAlign: TextAlign.right,
                  style: TextStyle(color: AppColors.grey),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _searchController,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن تخصص',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () => _showDoctors(),
                  icon: const Icon(Icons.people_outline),
                  label: const Text('عرض جميع الأطباء'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SpecialtyModel>>(
              future: _specialties,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _MessageState(
                    message:
                        'تعذر تحميل التخصصات. تحقق من الاتصال وحاول مجددًا.',
                    onRetry: () {
                      setState(() => _specialties = _service.getSpecialties());
                    },
                  );
                }

                final query = _searchController.text.trim().toLowerCase();
                final specialties = snapshot.data!
                    .where(
                      (specialty) =>
                          specialty.name.toLowerCase().contains(query),
                    )
                    .toList(growable: false);

                if (specialties.isEmpty) {
                  return const Center(child: Text('لا توجد تخصصات مطابقة.'));
                }

                return SpecialtyGridWidget(
                  specialties: specialties,
                  onSpecialtySelected: (specialty) => _showDoctors(
                    specialtyId: specialty.id,
                    specialtyName: specialty.name,
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
