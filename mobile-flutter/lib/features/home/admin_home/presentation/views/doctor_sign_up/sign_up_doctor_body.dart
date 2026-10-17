import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/function/homeIndicator.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_logo_section.dart';
import 'package:project1/features/home/admin_home/presentation/views/doctor_sign_up/sign_up_doctor_card.dart';

class SignUpDoctorBody extends StatefulWidget {
  const SignUpDoctorBody({super.key});

  @override
  State<SignUpDoctorBody> createState() => _SignUpDoctorBodyState();
}

class _SignUpDoctorBodyState extends State<SignUpDoctorBody> {
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
                    SignUpDoctorCard(),

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