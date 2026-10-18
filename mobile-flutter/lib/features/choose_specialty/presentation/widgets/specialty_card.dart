import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/features/choose_specialty/data/models/specialty_model.dart';
import 'package:project1/features/choose_specialty/presentation/widgets/specialty_image.dart';

class SpecialtyCard extends StatelessWidget {
  const SpecialtyCard({
    super.key,
    required this.specialty,
    required this.onTap,
  });

  final SpecialtyModel specialty;
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpecialtyImage(imagePath: specialty.imagePath, size: 60),
              const SizedBox(height: 12),
              Text(
                specialty.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'عرض الأطباء',
                style: TextStyle(fontSize: 12, color: AppColors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
