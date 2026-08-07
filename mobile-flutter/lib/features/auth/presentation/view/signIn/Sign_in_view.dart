import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/presentation/view/signIn/sign_in_body.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (_) => AuthCubit(),
  child: const SignInBody(),
);
  }
}