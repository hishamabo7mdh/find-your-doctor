import 'package:flutter/material.dart';
import 'package:project1/core/utils/app_colors.dart';

class TimeField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;

  const TimeField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.icon = Icons.access_time_rounded,
  });

  Future<void> _selectTime(BuildContext context) async {
    final now = TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: controller.text.isNotEmpty
          ? _parseTime(controller.text) ?? now
          : now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      controller.text =
          '${pickedTime.hour.toString().padLeft(2, '0')}:'
          '${pickedTime.minute.toString().padLeft(2, '0')}';
    }
  }

  TimeOfDay? _parseTime(String value) {
    try {
      final parts = value.split(':');

      if (parts.length != 2) return null;

      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectTime(context),
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: Icon(
              icon,
              color: AppColors.primaryColor,
            ),
            prefix: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}