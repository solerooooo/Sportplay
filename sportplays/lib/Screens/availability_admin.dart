import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking.dart';
import 'home.dart';
import 'profile.dart';
import 'qna.dart';
import '../models/user.dart';


class AvailabilityAdminPage extends StatefulWidget {
  final User passUser;

  const AvailabilityAdminPage({Key? key, required this.passUser})
      : super(key: key);
  @override
  _AvailabilityAdminPageState createState() => _AvailabilityAdminPageState();
}

class _AvailabilityAdminPageState extends State<AvailabilityAdminPage> {

  int pingPongCourts = 0;
  int badmintonCourts = 0;
  int squashCourts = 0;

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
  Map<String, int> selectedCourts = {};
  Set<String> selectedTimes = Set();
  // Add Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Function to update availability in Firestore
  void _updateAvailability(
      String time, int pingPongCourts, int badmintonCourts, int squashCourts) {
    _firestore.collection('availability').doc(time).set({
      'pingPongCourts': pingPongCourts,
      'badmintonCourts': badmintonCourts,
      'squashCourts': squashCourts,
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
            selectedTime: 'Choose you time slot',
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
    int currentPingPongCourts = selectedCourts['pingPong_$selectedTime'] ?? 0;
    int currentBadmintonCourts = selectedCourts['badminton_$selectedTime'] ?? 0;
    int currentSquashCourts = selectedCourts['squash_$selectedTime'] ?? 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedPingPongCourts = currentPingPongCourts;
        int selectedBadmintonCourts = currentBadmintonCourts;
        int selectedSquashCourts = currentSquashCourts;

        return AlertDialog(
          title: Text('Select number of courts for $selectedTime'),
          content: Column(
            children: [
              _buildCourtDropdown(
                'Ping Pong Courts',
                selectedPingPongCourts,
                (value) {
                  setState(() {
                    selectedPingPongCourts = value!;
                  });
                },
              ),
              _buildCourtDropdown(
                'Badminton Courts',
                selectedBadmintonCourts,
                (value) {
                  setState(() {
                    selectedBadmintonCourts = value!;
                  });
                },
              ),
              _buildCourtDropdown(
                'Squash Courts',
                selectedSquashCourts,
                (value) {
                  setState(() {
                    selectedSquashCourts = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedCourts['pingPong_$selectedTime'] =
                      selectedPingPongCourts;
                  selectedCourts['badminton_$selectedTime'] =
                      selectedBadmintonCourts;
                  selectedCourts['squash_$selectedTime'] = selectedSquashCourts;
                  _updateAvailability(
                    selectedTime,
                    selectedPingPongCourts,
                    selectedBadmintonCourts,
                    selectedSquashCourts,
                  );
                  Navigator.of(context).pop();
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
                        'Update Court Availability',
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
                height: 550,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    // Wrap with SingleChildScrollView
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
                                height: 110, // Changed height to 100
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeContainer(String time, int index) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('availability').doc(time).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return CircularProgressIndicator();
        }

        // Ensure that the fields exist in the document
        pingPongCourts = snapshot.data!['pingPongCourts'] ?? 0;
        badmintonCourts = snapshot.data!['badmintonCourts'] ?? 0;
        squashCourts = snapshot.data!['squashCourts'] ?? 0;

        return GestureDetector(
          onTap: () {
            _onTimeSelected(time);
          },
          child: Container(
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
                SizedBox(height: 8),
                Text('Ping Pong: $pingPongCourts'),
                Text('Badminton: $badmintonCourts'),
                Text('Squash: $squashCourts'),
              ],
            ),
          ),
        );
      },
    );
  }

Widget _buildCourtDropdown(
    String label, int value, void Function(int?) onChanged) {
  return FormField<int>(
    builder: (FormFieldState<int> state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Text(
                'Current $label: ${getCourtsByLabel(label)}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          DropdownButtonFormField<int>(
            value: value,
            onChanged: (newValue) {
              setState(() {
                value = newValue!;
              });
              onChanged(newValue);
            },
            items: List.generate(4, (index) => index)
                .map((int value) => DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    ))
                .toList(),
          ),
        ],
      );
    },
  );
}

  int getCourtsByLabel(String label) {
    switch (label) {
      case 'Ping Pong Courts':
        return pingPongCourts;
      case 'Badminton Courts':
        return badmintonCourts;
      case 'Squash Courts':
        return squashCourts;
      default:
        return 0;
    }
  }
}


