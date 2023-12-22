// editbookingdetails.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/screens/availability.dart';
import '../models/user.dart';

class EditBookingDetailsPage extends StatefulWidget {
  final User passUser;
  final String bookingId;
  final String selectedTime; 

  const EditBookingDetailsPage({
    Key? key,
    required this.passUser,
    required this.bookingId,
    required this.selectedTime, 
  }) : super(key: key);

  @override
  _EditBookingDetailsPageState createState() => _EditBookingDetailsPageState();
}

class _EditBookingDetailsPageState extends State<EditBookingDetailsPage> {
  String selectedActivity = 'Ping Pong';
  int playerQuantity = 1;
  String selectedPaymentMethod = 'Cash';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch booking details from Firestore based on bookingId
  Future<void> _fetchBookingDetails() async {
    try {
      DocumentSnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .doc(widget.passUser.getName())
          .collection('userBookings')
          .doc(widget.bookingId)
          .get();

      // Update state with fetched booking details
      setState(() {
        selectedActivity = bookingSnapshot['selectedActivity'];
        playerQuantity = bookingSnapshot['playerQuantity'];
        selectedPaymentMethod = bookingSnapshot['selectedPaymentMethod'];
        // Add more fields as needed
      });
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  // Update booking details in Firestore
  Future<void> _updateBookingDetails() async {
    try {
      DocumentReference bookingRef = _firestore
          .collection('bookings')
          .doc(widget.passUser.getName())
          .collection('userBookings')
          .doc(widget.bookingId);

      await bookingRef.update({
        'selectedActivity': selectedActivity,
        'playerQuantity': playerQuantity,
        'selectedPaymentMethod': selectedPaymentMethod,
        // Add more fields as needed
      });

      print('Booking details updated successfully!');
    } catch (e) {
      print('Error updating booking details: $e');
    }
  }

  // Save data to Firestore
  Future<void> _saveDataToFirestore() async {
    try {
      DocumentReference bookingRef = _firestore
          .collection('bookings')
          .doc(widget.passUser.getName())
          .collection('userBookings')
          .doc(widget.bookingId);

      await bookingRef.update({
        'selectedActivity': selectedActivity,
        'playerQuantity': playerQuantity,
        'selectedPaymentMethod': selectedPaymentMethod,
      });

      print('Data saved to Firestore successfully!');
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }

  // Delete booking from Firestore
  Future<void> _deleteBooking() async {
    try {
      await _firestore
          .collection('bookings')
          .doc(widget.passUser.getName())
          .collection('userBookings')
          .doc(widget.bookingId)
          .delete();

      print('Booking deleted successfully!');
      // Navigate back to the previous screen or handle navigation as needed
    } catch (e) {
      print('Error deleting booking: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  @override
  Widget build(BuildContext context) {
    // Similar UI structure as BookingPage, with fields prefilled with fetched details
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
        // Add other app bar customization as needed
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implement logic to navigate to AvailabilityPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailabilityPage(
                        passUser: widget.passUser,
                        sport: selectedActivity,
                        selectedTime: widget.selectedTime, // Add this line
                      ),
                    ),
                  );
                },
                style: selectedActivity == 'Choose your time slot'
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent)
                    : null,
                child: Text(
                  widget.selectedTime.isEmpty
                      ? 'Choose your time slot'
                      : '${widget.selectedTime}',
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
                  // Implement payment logic here
                  print('Selected Payment Method: $selectedPaymentMethod');
                },
                child: const Text('Make Payment'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Save data to Firestore
                  _saveDataToFirestore();
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // Save changes
                _updateBookingDetails();
                // Navigate back to the previous screen or handle navigation as needed
              },
              child: const Text('Save Changes'),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete booking
                _deleteBooking();
                // Navigate back to the previous screen or handle navigation as needed
              },
              child: const Text('Delete Booking'),
            ),
          ],
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
