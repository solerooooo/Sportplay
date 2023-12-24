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
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
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

  Future<void> stripeMakePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'MYR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: BillingDetails(
                      name: 'YOUR NAME',
                      email: 'YOUREMAIL@gmail.com',
                      phone: 'YOUR NUMBER',
                      address: Address(
                          city: 'YOUR CITY',
                          country: 'YOUR COUNTRY',
                          line1: 'YOUR ADDRESS 1',
                          line2: 'YOUR ADDRESS 2',
                          postalCode: 'YOUR PASSCODE',
                          state: 'YOUR STATE')),
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'SPORTPLAYS',))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _fetchNextBookingId() async {
    // Fetch the maximum bookingId from Firestore and increment it
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
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
                    stripeMakePayment();
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
  await FirebaseFirestore.instance.collection('Booking').doc('${booking.bookingId}').set({
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





displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }


//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
