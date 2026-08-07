import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view/signup/sign_up_body.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
        return BlocProvider(
  create: (_) => AuthCubit(),
  child: const SignUpBody(),
);
  }
}