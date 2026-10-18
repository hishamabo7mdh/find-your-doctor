import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/choose_specialty/data/models/doctor_model.dart';
import 'package:project1/features/choose_specialty/presentation/widgets/specialty_image.dart';

class DoctorTile extends StatelessWidget {
  const DoctorTile({super.key, required this.doctor, required this.onTap});

  final DoctorModel doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: ClipOval(
          child: Container(
            width: 50,
            height: 50,
            color: AppColors.backgroundColor,
            padding: const EdgeInsets.all(5),
            child: SpecialtyImage(
              imagePath: doctor.specialtyImagePath,
              size: 40,
            ),
          ),
        ),
        title: Text(
          doctor.name,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            [
              if (doctor.specialty?.isNotEmpty ?? false) doctor.specialty!,
              if (doctor.price != null) 'السعر: ${doctor.price}',
            ].join(' • '),
            textAlign: TextAlign.right,
          ),
        ),
        trailing: const Icon(Icons.chevron_left, color: AppColors.primaryColor),
      ),
    );
  }
}
