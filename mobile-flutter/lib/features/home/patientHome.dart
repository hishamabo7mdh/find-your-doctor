import 'package:flutter/material.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:MaterialApp(
        home: Center(
          child: Text("patientHome"),
        ),
      ),
    );
  }
}