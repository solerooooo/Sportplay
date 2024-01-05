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

  const ReminderPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Booking'),
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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFFE6DFF1),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextButton(
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
        Image.asset(
          imagePath,
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Handle button press for the specific activity
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
