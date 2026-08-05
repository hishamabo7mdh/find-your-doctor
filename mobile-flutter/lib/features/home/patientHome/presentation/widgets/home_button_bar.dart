import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,
      elevation: 0,

      backgroundColor: const Color(0xffC9F7F1),

      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,

      selectedLabelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12.sp,
      ),

      items: [
        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Icons.home_rounded,
            isSelected: currentIndex == 0,
          ),
          label: 'الرئيسية',
        ),

        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Icons.calendar_month_rounded,
            isSelected: currentIndex == 1,
          ),
          label: 'المواعيد',
        ),

        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Icons.medical_services_rounded,
            isSelected: currentIndex == 2,
          ),
          label: 'الأطباء',
        ),

        BottomNavigationBarItem(
          icon: _buildIcon(
            icon: Icons.settings_rounded,
            isSelected: currentIndex == 3,
          ),
          label: 'الإعدادات',
        ),
      ],
    );
  }

  Widget _buildIcon({
    required IconData icon,
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }
}