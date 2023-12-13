//availability.dart
import 'package:flutter/material.dart';
import 'booking.dart';
import 'home.dart';
import 'profile.dart';
import 'qna.dart';
import '../models/user.dart';

class AvailabilityPage extends StatefulWidget {
  final User passUser;
  final String sport; 
  const AvailabilityPage(
      {Key? key, required this.passUser, required this.sport})
      : super(key: key);

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
    // Handle the time selection, for example, navigate to the booking page
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
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('Court Availability'),
        backgroundColor: Colors.lightGreenAccent,
      ),
     body: Center(
  child: SingleChildScrollView(
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
          width: 400,
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
          width: 400,
          height: 530,
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
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
), );
  }
}

Widget _buildTimeContainer(String time) {
      return Container(
        width: 130,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            time,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    

 
