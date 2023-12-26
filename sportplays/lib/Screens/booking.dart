//booking.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/models/user.dart';
import 'package:sportplays/Screens/availability.dart';
import 'package:sportplays/Screens/home.dart';
import 'package:sportplays/Screens/profile.dart';
import 'package:sportplays/Screens/qna.dart';
import 'package:http/http.dart' as http;
import 'package:sportplays/screens/viewbookingdetails.dart';

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
  static const String chooseTimeSlotText = 'Choose your time slot';
  List<TextEditingController> playerControllers = [];
  late Booking booking;
  int _selectedIndex = 0;
  Map<String, dynamic>? paymentIntent;

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  @override
  void initState() {
    super.initState();

    // Initialize the booking object with default values
    booking = Booking(
      selectedActivity: 'Ping Pong',
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0,
      isCourtAssigned: null,
    );

    // Fetch the next available bookingId from Firestore
    _fetchNextBookingId();

    // Initialize playerControllers based on initial playerQuantity
    for (int i = 0; i < booking.playerQuantity; i++) {
      playerControllers.add(TextEditingController());
    }

    _updatePlayerControllers();
    _initializeBookingObject();
  }

  void _initializeBookingObject() {
    booking = Booking(
      selectedActivity: 'Ping Pong',
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0,
      isCourtAssigned: null,
    );
  }
  Future<void> _handleCashPayment() async {
  // Handle additional logic for Cash payment (update Firestore, etc.)
  // For now, let's show a pop-up message indicating a successful payment.
  await _showDonePaymentDialog();

  // Show "Done Booking" dialog
  _showDoneBookingDialog();
}

  void _fetchNextBookingId() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('Booking')
        .orderBy('bookingId', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      booking.bookingId = querySnapshot.docs.first['bookingId'] + 1;
    } else {
      booking.bookingId = 1;
    }
  }

  Future<void> stripeMakePayment() async {
    try {
      // Make a payment intent
      paymentIntent = await createPaymentIntent('5', 'MYR');

      if (paymentIntent != null) {
        // Initialize payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: 'SPORTPLAYS',
          ),
        );

        // Display payment sheet
        await displayPaymentSheet();
      } else {
        Fluttertoast.showToast(msg: 'Failed to create payment intent');
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment successfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      // Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print(
            'Failed to create payment intent. Status code: ${response.statusCode}');
        throw Exception('Failed to create payment intent. Please try again.');
      }
    } catch (err) {
      print('Error creating payment intent: ${err.toString()}');
      throw Exception('Error creating payment intent. Please try again.');
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Current Booking page, no need to navigate
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewBookingPage(
              passUser: widget.passUser,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(passUser: widget.passUser),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QnAPage(passUser: widget.passUser),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Profile(passUser: widget.passUser),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: Colors.lightGreenAccent,
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
    style: booking.selectedActivity == chooseTimeSlotText
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreenAccent)
        : null,
    child: Text(
      widget.selectedTime.isEmpty
          ? chooseTimeSlotText
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
                                  _updatePlayerControllers();
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
                                  _updatePlayerControllers();
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
                        'Fill up player names',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < booking.playerQuantity; i++)
                        TextField(
                          controller: playerControllers[i],
                          decoration: InputDecoration(
                            labelText: 'Player ${i + 1}',
                          ),
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
                            title: const Text('Debit/Credit Card'),
                            leading: Radio(
                              value: 'Debit/Credit Card',
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
                if (booking.selectedPaymentMethod == 'Debit/Credit Card')
                  ElevatedButton(
                    onPressed: () {
                      stripeMakePayment();
                      print(
                          'Selected Payment Method: $booking.selectedPaymentMethod');
                    },
                    child: const Text('Make Payment'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (booking.selectedPaymentMethod == 'Cash') {
                      _handleCashPayment();
                    } else {
                      _saveDataToFirestore();
                    }
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
            icon: Icon(Icons.add),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'View Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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

  void _updatePlayerControllers() {
    setState(() {
      playerControllers.clear();
      for (int i = 0; i < booking.playerQuantity; i++) {
        playerControllers.add(TextEditingController());
      }
    });
  }

  void _saveDataToFirestore() async {
    String userName = widget.passUser.name;
    List<String> playerNames = [];
    for (int i = 0; i < booking.playerQuantity; i++) {
      playerNames.add(playerControllers[i].text);
    }

    await FirebaseFirestore.instance
        .collection('Booking')
        .doc('${booking.bookingId}')
        .set({
      'bookingId': booking.bookingId,
      'userName': userName,
      'selectedActivity': booking.selectedActivity,
      'playerQuantity': booking.playerQuantity,
      'playerNames': playerNames,
      'selectedPaymentMethod': booking.selectedPaymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
      'selectedTime': widget.selectedTime,
    });

    setState(() {
      booking.bookingId = ++booking.bookingId;
    });
  }



  Future<void> _showDoneDialog(String title, String content) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDoneBookingDialog() async {
    await _showDoneDialog(
        'Done Booking', 'Your booking has been successfully completed!');
  }

  Future<void> _showDonePaymentDialog() async {
    await _showDoneDialog(
        'Done Payment', 'Your payment has been successfully completed!');
  }
}
