import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import '../models/user.dart';
import 'qna.dart';
import 'profile.dart';

class EditBookingDetailsPage extends StatefulWidget {
  final User passUser;
  final String selectedTime;

  const EditBookingDetailsPage({
    Key? key,
    required this.passUser,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _EditBookingDetailsPageState createState() => _EditBookingDetailsPageState();
}

class _EditBookingDetailsPageState extends State<EditBookingDetailsPage> {
  String selectedActivity = 'Ping Pong';
  int playerQuantity = 1;
  String selectedPaymentMethod = 'Cash';
  int _selectedIndex = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchBookingData();
  }

  void _fetchBookingData() async {
    try {
      String userName = widget.passUser.getName();
      DocumentSnapshot userBookingSnapshot =
          await _firestore.collection('bookings').doc(userName).get();

      if (userBookingSnapshot.exists) {
        setState(() {
          selectedActivity = userBookingSnapshot['selectedActivity'] ?? 'Ping Pong';
          playerQuantity = userBookingSnapshot['playerQuantity'] ?? 1;
          selectedPaymentMethod = userBookingSnapshot['selectedPaymentMethod'] ?? 'Cash';
        });
      }
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(passUser: widget.passUser),
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

  Future<void> _saveDataToFirestore() async {
    try {
      String userName = widget.passUser.getName();
      DocumentReference userBookingRef =
          _firestore.collection('bookings').doc(userName);

      await userBookingRef.update({
        'selectedActivity': selectedActivity,
        'playerQuantity': playerQuantity,
        'selectedPaymentMethod': selectedPaymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show SnackBar when changes are saved
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Current booking changes saved!'),
          duration: Duration(seconds: 2),
        ),
      );

      print('Data saved to Firestore successfully!');
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  Future<void> _deleteBooking() async {
    try {
      String userName = widget.passUser.getName();
      await _firestore.collection('bookings').doc(userName).delete();
      print('Booking deleted successfully!');
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
        backgroundColor: const Color(0xFFD6F454),
      ),
      body: Container(
        color: const Color(0xFFb364f3),
        child: Padding(
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
                    label: 'Ping Pong',
                  ),
                  _buildActivityButton(
                    activityName: 'Badminton',
                    label: 'Badminton',
                  ),
                  _buildActivityButton(
                    activityName: 'Squash',
                    label: 'Squash',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Number of Players',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (playerQuantity > 1) {
                                playerQuantity--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$playerQuantity',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (playerQuantity < 6) {
                                playerQuantity++;
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Payment Method',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        ListTile(
                          title: const Text('Cash'),
                          leading: Radio(
                            value: 'Cash',
                            groupValue: selectedPaymentMethod,
                            onChanged: (String? value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Free'),
                          leading: Radio(
                            value: 'Free',
                            groupValue: selectedPaymentMethod,
                            onChanged: (String? value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Online'),
                          leading: Radio(
                            value: 'Online',
                            groupValue: selectedPaymentMethod,
                            onChanged: (String? value) {
                              setState(() {
                                selectedPaymentMethod = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save data to Firestore
                  _saveDataToFirestore();
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Delete booking
                  _deleteBooking();
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const Text('Delete Booking'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Q&A',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityButton({
    required String activityName,
    required String label,
  }) {
    return ElevatedButton(
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
        child: Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
