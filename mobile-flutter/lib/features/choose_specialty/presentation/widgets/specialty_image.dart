import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project1/core/utils/app_colors.dart';

class SpecialtyImage extends StatelessWidget {
  const SpecialtyImage({super.key, this.imagePath, this.size = 60});

  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;
    if (path == null || path.isEmpty) return _fallback();

    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _fallback(),
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.backgroundColor,
      borderRadius: BorderRadius.circular(size * .25),
    ),
    child: Icon(
      Icons.medical_services_outlined,
      color: AppColors.primaryColor,
      size: size * .56,
    ),
  );
}
