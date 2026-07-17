import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/sharFunction.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/auth_tab_bar/auth_tab_bar.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/sign_in_form.dart';

class SignInCard extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  const SignInCard({super.key, required this.selectedTab, required this.onTabChanged,
    }) ;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          titleText(AppStrings.signInAr),
          SizedBox(height: 11.h,),

          AuthTabBarIndicator(
            selectedTab: selectedTab,
            onTabChanged: onTabChanged,
          ),
          SizedBox(height: 11.h,),

          IndexedStack(
            index: selectedTab,
            children: const [
            SignInForm(
                title: AppStrings.phoneNumberAr,
                hint:AppStrings.phoneHint,
                icon: Icons.phone,
              isPhone: true,


            ),
            SignInForm(
                title: AppStrings.emailAr,
                hint:AppStrings.emailHint,
                icon: Icons.email_outlined),
          ],
          )

        ]
      )
    );
  }

  BoxDecoration _decoration(){
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(30.r),
    );
  }
}

