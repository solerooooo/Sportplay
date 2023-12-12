import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking.dart';
import 'home.dart';
import 'profile.dart';
import 'qna.dart';
import '../models/user.dart';
class AvailabilityAdminPage extends StatefulWidget {
  final User passUser;
  final String sport;
  const AvailabilityAdminPage(
      {Key? key, required this.passUser, required this.sport})
      : super(key: key);
  @override
  _AvailabilityAdminPageState createState() => _AvailabilityAdminPageState();
}
class _AvailabilityAdminPageState extends State<AvailabilityAdminPage> {
  List<String> availableTimes = [
    '8AM-9AM',
    '9AM-10AM',
    '10AM-11AM',
    '11AM-12PM',
    '12PM-1PM',
    '1PM-2PM',
    '2PM-3PM',
    '3PM-4PM',
    '4PM-5PM',
    '5PM-6PM',
    '6PM-7PM',
    '7PM-8PM',
    '8PM-9PM',
    '9PM-10PM',
  ];
  Set<String> selectedTimes = Set();
  // Add Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   // Function to update availability in Firestore
  void _updateAvailability(String time, bool isAvailable) {
    _firestore.collection('availability').doc(time).set({
      'availability': isAvailable,
    });
  }
  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(passUser: widget.passUser),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingPage(
            passUser: widget.passUser,
            selectedTime: 'YourSelectedTimeHere',
          ),
        ),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QnAPage(passUser: widget.passUser),
        ),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(passUser: widget.passUser),
        ),
      );
    }
  }
  void _onTimeSelected(String selectedTime) {
    setState(() {
      if (selectedTimes.contains(selectedTime)) {
        selectedTimes.remove(selectedTime);
        _updateAvailability(selectedTime, true); // Set as available
      } else {
        selectedTimes.add(selectedTime);
        _updateAvailability(selectedTime, false); // Set as unavailable
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFb364f3),
      appBar: AppBar(
        title: const Text('Court Availability'),
        backgroundColor: Color(0xFFD6F454),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Court Availability',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 300,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFC9DB7E),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.sport}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 400,
                height: 800,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.access_time),
                            SizedBox(width: 8),
                            Text(
                              'Update Time Availability',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < availableTimes.length; i += 2)
                        Column(
                          children: [
                            SizedBox(
                              height: 90, // Changed height to 100
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildTimeContainer(availableTimes[i], i),
                                  if (i + 1 < availableTimes.length)
                                    _buildTimeContainer(
                                        availableTimes[i + 1], i + 1),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Widget _buildTimeContainer(String time, int index) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              time,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Switch(
            value: selectedTimes.contains(time),
            onChanged: (value) => _onTimeSelected(time),
          ),
        ],
      ),
    );
  }
}