// ignore_for_file: unused_import

import 'package:doctorschedule/doctormodule/docschedule.dart';
import 'package:flutter/material.dart';
import 'package/doctormodule/docschedule.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Appointment',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              onAppointmentCancelled: _handleAppointmentCancelled,
            ),
        '/doctor-schedule': (context) => DoctorSchedulePage(),
      },
    );
  }

  void _handleAppointmentCancelled() {
    // Implement logic to pass cancellation message to user module
    String message = "Appointments are cancelled";
    // Here you can send the message to the user module using any appropriate method
    // For example, you can use Provider or Riverpod to share the message with the user module.
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onAppointmentCancelled;

  HomeScreen({required this.onAppointmentCancelled});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/doctor-schedule');
              },
              child: Text('Doctor Schedule'),
            ),
            // Add other buttons or navigation options for the user module
          ],
        ),
      ),
    );
  }
}
