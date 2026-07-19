import 'package:flutter/material.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:MaterialApp(
        home: Center(
          child: Text("doctorHome"),
        ),
      ),
    );
  }
}