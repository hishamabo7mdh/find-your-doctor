import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_button.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_divider.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_text_field.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/create_account_section.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/remember_me_row.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/social_login_section.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';
class SignInForm extends StatefulWidget {
  final String title;
  final String hint;
  final IconData icon;
  final bool? isPhone;

  const SignInForm({super.key, required this.title, required this.hint, required this.icon, this.isPhone});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;
  bool rememberMe = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _firstFieldSection(),

          SizedBox(height: 11.h,),

          _passwordSection(),


          RememberMeRow(
            rememberMe: rememberMe,
            onChanged: _toggleRememberMe,
          ),

          SizedBox(height: 11.h,),

BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is AuthAuthenticated) {
      final role = state.user.role;

      if (role == "patient") {
        context.go(AppRouter.patientHome);
      } else if (role == "doctor") {
        context.go(AppRouter.doctorHome);
      } else if (role == "admin") {
        context.go(AppRouter.adminHome);
      }
    }

    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
        ),
      );
    }
  },
  builder: (context, state) {
    if (state is AuthLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AuthButton(
      text: AppStrings.signInAr,
      onPressed: () {
        context.read<AuthCubit>().login(
              login: emailController.text.trim(),
              password: passwordController.text,
            );
      },
    );
  },
),

          SizedBox(height: 11.h,),

          AccountSection(title: AppStrings.createAccountAr,AUSure: AppStrings.noAccountAr,onTap: (){context.go(AppRouter.signUp);},),

          SizedBox(height: 11.h,),

          const AuthDivider(),
          SizedBox(height: 11.h,),
          const SocialLoginSection(),

        ]
    );
  }
  Widget _firstFieldSection() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
            widget.title,
            style: CustomTextStyles.poppinsBoldBlack14
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          controller: emailController,
          hintText: widget.hint,
          keyboardType: widget.isPhone ?? false ? TextInputType.phone : null,


          obscureText: false,
          prefixIcon: Icon(widget.icon),

        ),
      ],
    );
  }

  Widget _passwordSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppStrings.passwordAr,
              style: CustomTextStyles.poppinsBoldBlack14
        ),
        SizedBox(height: 10.h),
        AuthTextField(
          controller: passwordController,
          hintText: AppStrings.passwordHintAr,
          obscureText: obscurePassword,
          prefixIcon: const Icon(Icons.lock_clock_outlined),
          suffixIcon: _passwordIcon(),
        )
      ],
    );
  }
  Widget _passwordIcon(){
      return IconButton(
        onPressed: _togglePassword,
        icon: Icon(
          obscurePassword
          ? Icons.visibility
          : Icons.visibility_off,
        )
      );
    }
    void _togglePassword(){
    setState(() {
      obscurePassword = !obscurePassword;
    });
    }

    void _toggleRememberMe(bool? value){
    setState(() {
      rememberMe = value!;
    });
    }
}
