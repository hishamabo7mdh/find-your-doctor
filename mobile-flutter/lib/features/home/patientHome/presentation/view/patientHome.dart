import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/home/patientHome/presentation/view_model/home_cubit/home_cubit.dart';
import 'package:project1/features/home/patientHome/presentation/widgets/home_body.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeCubit(),
    child: const HomeBody());
  }
}
