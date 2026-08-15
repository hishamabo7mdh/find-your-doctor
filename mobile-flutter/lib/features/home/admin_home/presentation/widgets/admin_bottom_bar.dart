import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';

class AdminBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const _AdminNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        title: 'الرئيسية',
      ),
      const _AdminNavItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        title: 'الأطباء',
      ),
      const _AdminNavItem(
        icon: Icons.calendar_month_outlined,
        activeIcon: Icons.calendar_month,
        title: 'المواعيد',
      ),
      const _AdminNavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        title: 'الإعدادات',
      ),
    ];

    return Container(
      height: 76.h,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];
            final isSelected = currentIndex == index;

            return GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 65.w : 55.w,
                padding: EdgeInsets.symmetric(
                  vertical: 7.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected
                          ? item.activeIcon
                          : item.icon,
                      size: 20.sp,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AdminNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;

  const _AdminNavItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
  });
}