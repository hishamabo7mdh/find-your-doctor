import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_logo_section.dart';
import 'package:project1/features/auth/presentation/widgets/sign_up_card.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
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
                    const SignInLogoSection(),
                    SizedBox(height: 25.h),

                    SignUpCard(),
                    SizedBox(height: 25.h,),
                    //_authTermsAgreementText(),

                    SizedBox(height: 25.h,),
                    homeIndicator(),
                    SizedBox(height: 11.h,),

                  ]
              ),
            ),
          ),
        ),
    );
  }

}