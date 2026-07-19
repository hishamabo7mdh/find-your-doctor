import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_logo_section.dart';
import 'package:project1/features/splash/view/splash_cubit.dart';
import 'package:project1/features/splash/view/splash_state.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
    if (state is SplashAuthenticated) {

      switch (state.user.role) {

        case "patient":
          context.go(AppRouter.patientHome);
          break;

        case "doctor":
          context.go(AppRouter.doctorHome);
          break;

        case "admin":
          context.go(AppRouter.adminHome);
          break;

      }

    }



        if (state is SplashUnauthenticated) {
          context.go(AppRouter.signIn);
        }
      },
      child: Scaffold(
          body:Container(
            width: double.infinity,
            color: AppColors.offWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInLogoSection(),

                SizedBox(height: 12.h),

                Text(
                  "SMB",
                  style: CustomTextStyles.PacificoBoldsecondaryColor64,
                ),

                SizedBox(height: 10.h),

                Text(
                  "Smart Medical Booking",
                  style: CustomTextStyles.poppinsMediumWhite18,
                ),
              ],
            ),
          ),
      ),
    );


  }
}
