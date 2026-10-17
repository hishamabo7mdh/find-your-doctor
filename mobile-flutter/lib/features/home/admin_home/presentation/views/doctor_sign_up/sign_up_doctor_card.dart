import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/features/auth/presentation/sharFunction.dart';
import 'package:project1/features/home/admin_home/presentation/views/doctor_sign_up/sign_up_doctor_form.dart';

class SignUpDoctorCard extends StatelessWidget {
  const SignUpDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.w),
        decoration: _decoration(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              titleText(AppStrings.signUpAr),

              SizedBox(height: 11.h,),
              
              SignUpDoctorForm()

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
