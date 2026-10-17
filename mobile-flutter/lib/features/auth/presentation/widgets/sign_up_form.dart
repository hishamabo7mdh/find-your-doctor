import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/features/auth/presentation/view/signup/common_auth_fields.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_button.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/create_account_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CommonAuthFields(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          obscurePassword: obscurePassword,
          obscureConfirmPassword: obscureConfirmPassword,
          onTogglePassword: _togglePassword,
          onToggleConfirmPassword: _toggleConfirmPassword,
        ),
        SizedBox(height: 11.h),
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go(AppRouter.patientHome);
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return AuthButton(
              text: AppStrings.signUpAr,
              onPressed: () {
                context.read<AuthCubit>().register(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  email: emailController.text.trim(),
                  phone: phoneController.text.trim(),
                  password: passwordController.text,
                  passwordConfirmation: confirmPasswordController.text,
                );
              },
            );
          },
        ),
        SizedBox(height: 11.h),
        AccountSection(
          title: AppStrings.signInAr,
          AUSure: AppStrings.haveAccountAr,
          onTap: () {
            context.go(AppRouter.signIn);
            // context.go(AppRouter.registerDoctor);
          },
        ),
      ],
    );
  }

  void _togglePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      obscureConfirmPassword = !obscureConfirmPassword;
    });
  }
}
