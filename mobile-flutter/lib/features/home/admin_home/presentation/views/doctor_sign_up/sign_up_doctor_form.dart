import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/core/utils/app_colors.dart';
import 'package:project1/core/utils/app_strings.dart';
import 'package:project1/features/auth/presentation/view/signup/common_auth_fields.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/auth_button.dart';
import 'package:project1/features/auth/presentation/widgets/sign_in_card/sign_in_form/create_account_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/auth/presentation/view_model/auth_state.dart';
import 'package:project1/features/auth/data/services/specialty_service.dart';
import 'package:project1/features/home/patientHome/data/models/specialty_model.dart';
import 'package:project1/features/home/admin_home/presentation/views/doctor_sign_up/widgets/time_Field.dart';

class SignUpDoctorForm extends StatefulWidget {
  const SignUpDoctorForm({super.key});

  @override
  State<SignUpDoctorForm> createState() => _SignUpDoctorFormState();
}

class _SignUpDoctorFormState extends State<SignUpDoctorForm> {
  final List<String> selectedDays = [];
  final _specialtyService = SpecialtyService();
  late Future<List<SpecialtyModel>> _specialties;
  int? selectedSpecialtyId;
  bool isActive = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _specialties = _specialtyService.getSpecialties();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthDoctorCreated) {
          context.go(AppRouter.adminHome);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
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

              _specialtySelector(),

              SizedBox(height: 11.h),

              _daysSelector(),

              SizedBox(height: 11.h),

              TimeField(
                title: 'وقت بداية الدوام',
                hint: '09:00',
                controller: startTimeController,
              ),
              SizedBox(height: 11.h),
              TimeField(
                title: 'وقت نهاية الدوام',
                hint: '17:00',
                controller: endTimeController,
              ),

              SizedBox(height: 11.h),

              Directionality(
                textDirection: TextDirection.rtl,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('الدوام فعال'),
                  value: isActive,
                  activeThumbColor: AppColors.primaryColor,
                  activeTrackColor: AppColors.primaryColor.withOpacity(0.4),
                  onChanged: (value) {
                    setState(() {
                      isActive = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 20.h),

              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AuthButton(
                      text: 'إنشاء حساب الدكتور',
                      onPressed: _createDoctor,
                    ),
              AccountSection(
                title: AppStrings.signInAr,
                AUSure: AppStrings.haveAccountAr,
                onTap: () {
                  context.go(AppRouter.signIn);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _specialtySelector() {
    return FutureBuilder<List<SpecialtyModel>>(
      future: _specialties,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(
                  () => _specialties = _specialtyService.getSpecialties(),
                );
              },
              child: const Text('تعذر تحميل الاختصاصات - أعد المحاولة'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Align(
            alignment: Alignment.centerRight,
            child: CircularProgressIndicator(),
          );
        }

        final specialties = snapshot.data!;
        return DropdownButtonFormField<int>(
          initialValue: selectedSpecialtyId,
          decoration: InputDecoration(
            labelText: 'الاختصاص الطبي',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          items: specialties
              .map(
                (specialty) => DropdownMenuItem<int>(
                  value: specialty.id,
                  child: Text(specialty.name),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedSpecialtyId = value),
        );
      },
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

  Widget _daysSelector() {
    const days = [
      ('saturday', 'السبت'),
      ('sunday', 'الأحد'),
      ('monday', 'الاثنين'),
      ('tuesday', 'الثلاثاء'),
      ('wednesday', 'الأربعاء'),
      ('thursday', 'الخميس'),
      ('friday', 'الجمعة'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'أيام الدوام',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          alignment: WrapAlignment.end,
          children: days.map((day) {
            final selected = selectedDays.contains(day.$1);

            return FilterChip(
              label: Text(day.$2),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  value
                      ? selectedDays.add(day.$1)
                      : selectedDays.remove(day.$1);
                });
              },
              selectedColor: AppColors.primaryColor.withOpacity(.12),
              checkmarkColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color: selected ? AppColors.primaryColor : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
              side: BorderSide(
                color: selected ? AppColors.primaryColor : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _createDoctor() {
    if (selectedSpecialtyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار اختصاص الطبيب.')),
      );
      return;
    }

    context.read<AuthCubit>().createDoctor(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      passwordConfirmation: confirmPasswordController.text,
      daysOfWeek: selectedDays,
      startTime: startTimeController.text.trim(),
      endTime: endTimeController.text.trim(),
      isActive: isActive,
      specialtyId: selectedSpecialtyId,
    );
  }
}
