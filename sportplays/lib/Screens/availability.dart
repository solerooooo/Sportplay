//availability.dart
import 'package:flutter/material.dart';
import 'booking.dart';
import 'home.dart';
import 'profile.dart';
import 'qna.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityPage extends StatefulWidget {
  final User passUser;
  final String sport;
  final String selectedTime; // Add this line

  const AvailabilityPage({
    Key? key,
    required this.passUser,
    required this.sport,
    required this.selectedTime, // Add this line
  }) : super(key: key);

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
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
            selectedTime: 'Choose your time slot',
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
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BookingPage(
        passUser: widget.passUser,
        selectedTime: selectedTime,
      ),
    ),
  );
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
                width: 200,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.lightGreenAccent,
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
                              'Time',
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
                              height: 75,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _onTimeSelected(availableTimes[i]),
                                    child:
                                        _buildTimeContainer(availableTimes[i]),
                                  ),
                                  if (i + 1 < availableTimes.length)
                                    GestureDetector(
                                      onTap: () => _onTimeSelected(
                                          availableTimes[i + 1]),
                                      child: _buildTimeContainer(
                                          availableTimes[i + 1]),
                                    ),
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

  Widget _buildTimeContainer(String time) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('availability')
          .doc(time)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return CircularProgressIndicator();
        }

        int pingPongCourts = 0;
        int badmintonCourts = 0;
        int squashCourts = 0;

        if (widget.sport == 'Ping Pong') {
          pingPongCourts = snapshot.data!['pingPongCourts'] ?? 0;
        } else if (widget.sport == 'Badminton') {
          badmintonCourts = snapshot.data!['badmintonCourts'] ?? 0;
        } else if (widget.sport == 'Squash') {
          squashCourts = snapshot.data!['squashCourts'] ?? 0;
        }

        bool isCourtAvailable = false;
        if (widget.sport == 'Ping Pong' && pingPongCourts > 0) {
          isCourtAvailable = true;
        } else if (widget.sport == 'Badminton' && badmintonCourts > 0) {
          isCourtAvailable = true;
        } else if (widget.sport == 'Squash' && squashCourts > 0) {
          isCourtAvailable = true;
        }

        return GestureDetector(
          onTap: () {
            if (isCourtAvailable) {
              _onTimeSelected(time);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Court is full. Please select another time slot.'),
                ),
              );
            }
          },
          child: Container(
            width: 155,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
              color: isCourtAvailable ? Colors.green : Colors.red,
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    time,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 8),
                if (widget.sport == 'Ping Pong')
                  Text('Ping Pong: $pingPongCourts',
                      style: TextStyle(color: Colors.white)),
                if (widget.sport == 'Badminton')
                  Text('Badminton: $badmintonCourts',
                      style: TextStyle(color: Colors.white)),
                if (widget.sport == 'Squash')
                  Text('Squash: $squashCourts',
                      style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );
      },
    );
  }
}
