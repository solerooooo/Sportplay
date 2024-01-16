//booking.dart
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportplays/model/bookingdetails.dart';
import 'package:sportplays/model/user.dart';
import 'package:sportplays/screen/availability.dart';
import 'package:sportplays/screen/home.dart';
import 'package:sportplays/screen/profile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class BookingPage extends StatefulWidget {
  final User passUser;
  final String selectedTime;
  final String selectedActivity;
  final Timestamp? timestamp;

  const BookingPage({
    Key? key,
    required this.passUser,
    required this.selectedActivity,
    required this.selectedTime,
    required this.timestamp,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static const String chooseTimeSlotText = 'Choose your time slot';
  List<TextEditingController> playerControllers = [];
  late Booking booking;
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
      selectedActivity: 'pingpong',
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0,
      isCourtAssigned: null,
      playerNames: [],
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
      selectedActivity: widget.selectedActivity,
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0,
      isCourtAssigned: null,
      playerNames: [],
    );
  }

  /*Future<void> _handleCashPayment() async {
    // Handle additional logic for Cash payment (update Firestore, etc.)
    // For now, let's show a pop-up message indicating a successful payment.
    await _showDonePaymentDialog();

    // Show "Done Booking" dialog
    _showDoneBookingDialog();
  }*/

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
      //Fluttertoast.showToast(msg: 'Payment successfully completed');
      _showDonePaymentDialog();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Booking'),
        leading: GestureDetector(
          onTap: () {
            // Navigate to the home screen
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
                // Navigate to the profile screen
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
                      _saveDataToFirestore();
                    },
                    child: const Text('Make Payment'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (booking.selectedPaymentMethod == 'Cash') {
                      _showDoneBookingDialog();
                      _saveDataToFirestore();
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(passUser: widget.passUser),
                  ),
                );
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
