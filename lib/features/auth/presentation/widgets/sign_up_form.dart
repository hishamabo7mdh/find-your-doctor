import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_button.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_text_field.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/create_account_section.dart';
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _firstFieldSection(
              AppStrings.fullNameAr,
              AppStrings.fullNameHintAr,
              Icons.person_outline
          ),

          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.emailAr,
              AppStrings.emailHint,
              Icons.email_outlined
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.phoneNumberAr,
              AppStrings.phoneHint,
              Icons.phone,
              textIType: TextInputType.phone
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
            AppStrings.passwordAr,
            AppStrings.passwordHintAr,
            Icons.lock_clock_outlined,
            suffixIcon: _passwordIcon(),
            condpass: true
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.confirmPasswordAr,
              AppStrings.confirmPasswordHintAr,
              Icons.lock_clock_outlined,
              suffixIcon: _passwordIcon(),
              condpass: true
          ),
          SizedBox(height: 11.h,),
          AuthButton(text: AppStrings.signUpAr, onPressed: (){}),
          SizedBox(height: 11.h,),
          AccountSection(title: AppStrings.signInAr,AUSure: AppStrings.haveAccountAr,onTap: (){context.go(AppRouter.splash);},),
        ]
    );
  }

  Widget _firstFieldSection(String title, String hint, IconData icon,
      {TextInputType textIType = TextInputType.emailAddress,Widget? suffixIcon,bool condpass=false}

      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
            title,
            style: CustomTextStyles.poppinsBoldBlack14
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          hintText: hint,
          keyboardType: textIType,
          obscureText: condpass?obscurePassword:condpass ,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon ,
        ),
      ],
    );
  }

  Widget _passwordIcon() {
    return IconButton(
        onPressed: _togglePassword,
        icon: Icon(
          obscurePassword
              ? Icons.visibility
              : Icons.visibility_off,
        )
    );
  }

  void _togglePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }
}


