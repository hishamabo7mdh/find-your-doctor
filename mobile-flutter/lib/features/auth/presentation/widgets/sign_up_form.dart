import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/core/utils/app_text_styles.dart';
import 'package:project1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_button.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_text_field.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/create_account_section.dart';
import 'package:provider/provider.dart';
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;

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
          _firstFieldSection(
              AppStrings.fullNameAr,
              AppStrings.fullNameHintAr,
              Icons.person_outline,
              controller: firstNameController,
          ),

          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.emailAr,
              AppStrings.emailHint,
              Icons.email_outlined,
              controller: emailController,
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.phoneNumberAr,
              AppStrings.phoneHint,
              Icons.phone,
              controller: phoneController,
              textIType: TextInputType.phone,
              
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
            AppStrings.passwordAr,
            AppStrings.passwordHintAr,
            Icons.lock_clock_outlined,
            controller: passwordController,
            suffixIcon: _passwordIcon(),
            condpass: true
          ),
          SizedBox(height: 11.h,),
          _firstFieldSection(
              AppStrings.confirmPasswordAr,
              AppStrings.confirmPasswordHintAr,
              Icons.lock_clock_outlined,
              controller: confirmPasswordController,
              suffixIcon: _passwordIcon(),
              condpass: true
          ),
          SizedBox(height: 11.h,),
          AuthButton(text: AppStrings.signUpAr,  onPressed: () async {
    final vm = context.read<AuthViewModel>();

    final name = firstNameController.text.trim().split(" ");

    final success = await vm.register(
      firstName: name.first,
      lastName: name.length > 1 ? name.sublist(1).join(" ") : "",
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
    );
if (success) {
  context.go(AppRouter.patientHome);
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        vm.error ?? "فشل إنشاء الحساب",
      ),
    ),
  );
}
  },
  ),
          SizedBox(height: 11.h,),
          AccountSection(title: AppStrings.signInAr,AUSure: AppStrings.haveAccountAr,onTap: (){context.go(AppRouter.signIn);},),
        ]
    );
  }

  Widget _firstFieldSection(String title, String hint, IconData icon,
      {required TextEditingController controller,TextInputType textIType = TextInputType.emailAddress,Widget? suffixIcon,bool condpass=false}

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
          controller: controller,
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


