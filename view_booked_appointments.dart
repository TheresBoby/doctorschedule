import 'package:flutter/material.dart';

class ViewAppointmentsPage extends StatefulWidget {
  @override
  _ViewAppointmentsPageState createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  final Map<String, List<Appointment>> appointments = {
    '2023-05-01': [
      Appointment(
        username: 'John Doe',
        timeSlot: '10:00 AM',
        attended: false,
      ),
      Appointment(
        username: 'Jane Smith',
        timeSlot: '11:30 AM',
        attended: false,
      ),
    ],
    '2023-05-02': [
      Appointment(
        username: 'Bob Johnson',
        timeSlot: '2:00 PM',
        attended: true,
      ),
      Appointment(
        username: 'Alice Williams',
        timeSlot: '3:30 PM',
        attended: false,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Appointments'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final dateKey = appointments.keys.toList()[index];
          final appointmentsForDate = appointments[dateKey]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateKey,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cancel Appointments'),
                            content: Text(
                                'Do you want to cancel all appointments for $dateKey?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    appointments.remove(dateKey);
                                  });
                                  // Notify users that their appointments are canceled
                                  for (var appointment in appointmentsForDate) {
                                    notifyUser(appointment.username);
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: appointmentsForDate.length,
                itemBuilder: (context, appointmentIndex) {
                  final appointment = appointmentsForDate[appointmentIndex];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                            '${appointment.username} - ${appointment.timeSlot}'),
                        trailing: TextButton(
                          onPressed: () {
                            setState(() {
                              appointment.attended = !appointment.attended;
                            });
                          },
                          child: Text(
                            appointment.attended ? 'Attended' : 'Attend',
                            style: TextStyle(
                              color: appointment.attended ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void notifyUser(String username) {
    // Implement your logic to notify the user with the given username
    // that their appointment has been canceled.
    // This could involve sending a push notification, email, or any other communication method.
    print('Notifying $username that their appointment has been canceled.');
  }
}

class Appointment {
  final String username;
  final String timeSlot;
  bool attended;

  Appointment({
    required this.username,
    required this.timeSlot,
    this.attended = false,
  });
}
