import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/home/admin_home/presentation/views/doctor_sign_up/sign_up_doctor_body.dart';

class BodyDoctorForm extends StatelessWidget {
  const BodyDoctorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (_) => AuthCubit(),
  child: const SignUpDoctorBody(),
);
  }
}