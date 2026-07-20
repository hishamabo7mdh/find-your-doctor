import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/core/routing/app_router.dart';
import 'package:project1/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:project1/core/routing/app_router.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MaterialApp(
        home: Center(
          child: Column(
            children: [
              Text("patientHome"),
              ElevatedButton(
                onPressed: () async {
                  final vm = context.read<AuthViewModel>();

                  await vm.logout();

                  if (context.mounted) {
                    context.go(AppRouter.signIn);
                  }
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
