import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/auth_tab_bar/auth_tab_item.dart';

class AuthTabBarIndicator extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  const AuthTabBarIndicator({super.key, required this.selectedTab, required this.onTabChanged, });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _decoration(),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(0),
              child: AuthTabItem(
                title: "رقم الجوال",
                isSelected: selectedTab == 0,
    ),
    ),
    ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(1),
              child: AuthTabItem(
                title: "البريد الإلكتروني",
                isSelected: selectedTab == 1,
    ),
    ),
    ),
    ],
    ),
    );

  }
  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  BoxDecoration _indicatorDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: const [
        BoxShadow(
          blurRadius: 4,
          color: AppColors.secondaryColor,
        ),
      ],
    );
  }
}
