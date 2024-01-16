import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../model/user.dart';
import 'package:sportplays/screen/notifi_service.dart';
import 'package:sportplays/screen/home.dart';
import 'package:sportplays/screen/profile.dart';
import 'package:flutter/cupertino.dart';

DateTime scheduleTime = DateTime.now();


class ReminderPage extends StatefulWidget {
  final User passUser;
  final String selectedActivity;

  const ReminderPage({
    Key? key,
    required this.passUser,
    required this.selectedActivity,
  }) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  String selectedActivity = ''; // Define selectedActivity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Reminder'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(passUser: widget.passUser),
              ),
            );
          },
          child: Icon(
            CupertinoIcons.home,
            size: 26,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(passUser: widget.passUser),
                  ),
                );
              },
              child: Icon(
                CupertinoIcons.person,
                size: 26,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
      backgroundColor: Color(0xFFE6DFF1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Activity',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActivityButton(
                    activityName: 'Ping Pong',
                    imagePath: 'images/pingpong.png',
                    label: 'Ping Pong',
                  ),
                  _buildActivityButton(
                    activityName: 'Badminton',
                    imagePath: 'images/badminton.png',
                    label: 'Badminton',
                  ),
                  _buildActivityButton(
                    activityName: 'Squash',
                    imagePath: 'images/squash.png',
                    label: 'Squash',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );

                  if (pickedDateTime != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        scheduleTime = DateTime(
                          pickedDateTime.year,
                          pickedDateTime.month,
                          pickedDateTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: const Text(
                  'Select Date Time',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                child: const Text('Set Reminder'),
                onPressed: () {
                  debugPrint('Notification Scheduled for $scheduleTime');
                  NotificationService().scheduleNotification(
                    title: 'Scheduled Notification',
                    body: '$scheduleTime',
                    scheduledNotificationDateTime: scheduleTime,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityButton({
    required String activityName,
    required String imagePath,
    required String label,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedActivity = activityName;
            });
          },
          style: selectedActivity == activityName
              ? ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              imagePath,
              height: 30,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }
}
