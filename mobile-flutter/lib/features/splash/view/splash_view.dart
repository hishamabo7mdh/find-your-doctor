import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/splash/view/splash_body.dart';
import 'package:project1/features/splash/view/splash_cubit.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_)=>SplashCubit()..startSplash(),
      child: const SplashBody(),
    );
  }
}

