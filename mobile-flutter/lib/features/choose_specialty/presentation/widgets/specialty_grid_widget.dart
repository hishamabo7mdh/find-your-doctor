import 'package:flutter/material.dart';
import 'package:project1/features/choose_specialty/data/models/specialty_model.dart';
import 'package:project1/features/choose_specialty/presentation/widgets/specialty_card.dart';

class SpecialtyGridWidget extends StatelessWidget {
  const SpecialtyGridWidget({
    super.key,
    required this.specialties,
    required this.onSpecialtySelected,
  });

  final List<SpecialtyModel> specialties;
  final ValueChanged<SpecialtyModel> onSpecialtySelected;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.12,
      ),
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final specialty = specialties[index];
        return SpecialtyCard(
          specialty: specialty,
          onTap: () => onSpecialtySelected(specialty),
        );
      },
    );
  }
}
