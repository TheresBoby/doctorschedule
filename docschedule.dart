import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorSchedulePage extends StatefulWidget {
  @override
  _DoctorSchedulePageState createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _slotDuration = 15; // Duration of each time slot in minutes
  List<String> _scheduledTimeSlots = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Schedule'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _startTime = pickedTime;
                    });
                  }
                },
                child: Text('Start Time'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _startTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _endTime = pickedTime;
                    });
                  }
                },
                child: Text('End Time'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Slot Duration (minutes): '),
                SizedBox(width: 8.0),
                DropdownButton<int>(
                  value: _slotDuration,
                  items: [15, 30, 45, 60]
                      .map(
                        (duration) => DropdownMenuItem<int>(
                          value: duration,
                          child: Text('$duration'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _slotDuration = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _generateTimeSlots();
            },
            child: Text('Schedule'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _scheduledTimeSlots.length,
              itemBuilder: (context, index) {
                return TimeSlotTile(
                  timeSlot: _scheduledTimeSlots[index],
                  onTap: () {
                    // Handle time slot selection
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _generateTimeSlots() {
    if (_selectedDay == null || _startTime == null || _endTime == null) {
      return;
    }

    final start = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final end = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('End time should be after start time'),
        ),
      );
      return;
    }

    final scheduledTimeSlots = <String>[];
    var currentTime = start;

    while (currentTime.isBefore(end)) {
      final timeSlot = '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
      scheduledTimeSlots.add(timeSlot);
      currentTime = currentTime.add(Duration(minutes: _slotDuration));
    }

    setState(() {
      _scheduledTimeSlots = scheduledTimeSlots;
    });
  }
}

class TimeSlotTile extends StatelessWidget {
  final String timeSlot;
  final VoidCallback onTap;

  TimeSlotTile({
    required this.timeSlot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(timeSlot),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Handle removing the time slot
        },
      ),
      onTap: onTap,
    );
  }
}