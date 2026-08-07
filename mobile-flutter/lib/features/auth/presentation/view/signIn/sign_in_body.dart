import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_card.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_logo_section.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({super.key}) ;

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> with SingleTickerProviderStateMixin {
  //late final TabController _tabController;
  int selectedTab = 0;
  void changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                const SignInLogoSection(),
                SizedBox(height: 25.h),

                SignInCard(
                  selectedTab: selectedTab,
                  onTabChanged: changeTab,
                ),
                SizedBox(height: 25.h,),
                _authTermsAgreementText(),

                SizedBox(height: 25.h,),
                homeIndicator(),
                SizedBox(height: 11.h,),

              ]
            ),
          ),
        ),
      )
    );
  }




  RichText _authTermsAgreementText() {
    return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
                  color: AppColors.offWhite
                ),
              children:[
              TextSpan(text: AppStrings.agreeTextAr),
                TextSpan(text: AppStrings.termsAndConditionsAr,style: CustomTextStyles.poppinsRegularTextGreyText14.copyWith(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                )),
              ]

              ),

            );
  }
}
