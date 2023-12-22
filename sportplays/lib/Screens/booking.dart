import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Models/constants.dart';
import 'package:sportplays/models/user.dart';
import 'package:sportplays/Screens/availability.dart';
import 'package:sportplays/Screens/home.dart';
import 'package:sportplays/Screens/profile.dart';
import 'package:sportplays/Screens/qna.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookingPage extends StatefulWidget {
  final User passUser;
  final String selectedTime;

  const BookingPage({
    Key? key,
    required this.passUser,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late Booking booking;
  int _selectedIndex = 0;
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
_razorpay.clear(); // Removes all listeners
    // Initialize the booking object with default values
    booking = Booking(
      selectedActivity: 'Ping Pong',
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0, // Set initial value to 0 or null
    );

    // Fetch the next available bookingId from Firestore
    _fetchNextBookingId();
  }

  void _openRazorpay() {
    var options = {
      'key': Constants.razorpayKey,
      'amount': Constants.defaultAmount,
      'name': 'Your App Name',
      'description': 'Payment for booking',
      'prefill': {
        'contact': Constants.contactNumber,
        'email': Constants.userEmail,
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
      // Handle error, show a snackbar or alert dialog
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success: ${response.paymentId}");
    // Implement your logic here after successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment error: ${response.message}");
    // Implement your logic here for payment failure
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet: ${response.walletName}");
    // Implement your logic here for external wallet selection
  }

  

  void _fetchNextBookingId() async {
    // Fetch the maximum bookingId from Firestore and increment it
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Booking')
        .orderBy('bookingId', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If there are existing bookings, get the highest bookingId and increment it
      booking.bookingId = querySnapshot.docs.first['bookingId'] + 1;
    } else {
      // If no existing bookings, start with bookingId = 1
      booking.bookingId = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: const Color(0xFFD6F454),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFE6DFF1),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvailabilityPage(
                          passUser: widget.passUser,
                          sport: booking.selectedActivity,
                          selectedTime: widget.selectedTime,
                        ),
                      ),
                    );
                  },
                  style: booking.selectedActivity == 'Choose your time slot'
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (booking.playerQuantity > 1) {
                                  booking.playerQuantity--;
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '${booking.playerQuantity}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (booking.playerQuantity < 6) {
                                  booking.playerQuantity++;
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          ListTile(
                            title: const Text('Cash'),
                            leading: Radio(
                              value: 'Cash',
                              groupValue: booking.selectedPaymentMethod,
                              onChanged: (String? value) {
                                setState(() {
                                  booking.selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Free'),
                            leading: Radio(
                              value: 'Free',
                              groupValue: booking.selectedPaymentMethod,
                              onChanged: (String? value) {
                                setState(() {
                                  booking.selectedPaymentMethod = value!;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Online'),
                            leading: Radio(
                              value: 'Online',
                              groupValue: booking.selectedPaymentMethod,
                              onChanged: (String? value) {
                                setState(() {
                                  booking.selectedPaymentMethod = value!;
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
                    _openRazorpay();
                    print(
                        'Selected Payment Method: $booking.selectedPaymentMethod');
                  },
                  child: const Text('Make Payment'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Show "Done Booking" dialog
                    _showDoneBookingDialog();
                    // Save data to Firestore
                    _saveDataToFirestore();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
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
    required String imagePath,
    required String label,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              booking.selectedActivity = activityName;
            });
          },
          style: booking.selectedActivity == activityName
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

  void _saveDataToFirestore() async {
    // Access userName from the User object
    String userName = widget.passUser.name;

    // Add your Firestore logic here to save data with the bookingId as the document ID
    await FirebaseFirestore.instance
        .collection('Booking')
        .doc('${booking.bookingId}')
        .set({
      'bookingId': booking.bookingId, // Add bookingId field
      'userName': userName,
      'selectedActivity': booking.selectedActivity,
      'playerQuantity': booking.playerQuantity,
      'selectedPaymentMethod': booking.selectedPaymentMethod,
      'timestamp': FieldValue.serverTimestamp(), // Add timestamp field
      'selectedTime': widget.selectedTime, // Add selectedTime field
      // Add other fields as needed
    });

    setState(() {
      // Use pre-increment or alternative way to increment bookingId
      booking.bookingId = ++booking.bookingId;
    });
  }

  Future<void> _showDoneBookingDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Done Booking'),
          content: Text('Your booking has been successfully completed!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(passUser: widget.passUser),
                  ),
                ); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
