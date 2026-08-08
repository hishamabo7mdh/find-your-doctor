import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project1/core/utils/router.dart';
import 'package:project1/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:project1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel())],
      child: const Project1App(),
    ),
  );
  //runApp(const Project1App());
}

class Project1App extends StatelessWidget {
  const Project1App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => AuthCubit(),
          child: MaterialApp.router(
            routerConfig: routerList,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
