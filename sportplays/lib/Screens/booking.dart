import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  Map<String, dynamic>? paymentIntentData;
  String money = 2.toString();

  @override
  void initState() {
    super.initState();

    booking = Booking(
      selectedActivity: 'Ping Pong',
      playerQuantity: 1,
      selectedPaymentMethod: 'Cash',
      selectedTime: 'Choose your time slot',
      bookingId: 0,
    );

    _fetchNextBookingId();
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
                   makePayment();
                   print('Selected Payment Method: ${booking.selectedPaymentMethod}');
 },
                  child: const Text('Make Payment'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showDoneBookingDialog();
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
    String userName = widget.passUser.name;

    await FirebaseFirestore.instance
        .collection('Booking')
        .doc('${booking.bookingId}')
        .set({
      'bookingId': booking.bookingId,
      'userName': userName,
      'selectedActivity': booking.selectedActivity,
      'playerQuantity': booking.playerQuantity,
      'selectedPaymentMethod': booking.selectedPaymentMethod,
      'timestamp': FieldValue.serverTimestamp(),
      'selectedTime': widget.selectedTime,
    });

    setState(() {
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
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

   payFee() {
    try {
      //if you want to upload data to any database do it here
    } catch (e) {
      // exception while uploading data
    }
  }


  Future<void> makePayment() async {
    try {
       Map<String, dynamic> body = {
        'amount': (double.parse(money) * 100).toInt().toString(),
        'currency': "MYR",
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 
            'Bearer sk_test_51L8PzGKEp9uhBKrrWhzpS6OoCZSlUfjEakjHRoLwBOrcSLeUDUZZw1QbX7BgWXjV6w9SMcDLAUlRzorynyrC1OrV00c4HIw4Ns',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      paymentIntentData = json.decode(response.body);
    } catch (error) {
      throw Exception(error);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.initPaymentSheet(

          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              style: ThemeMode.light,
              merchantDisplayName: 'SPORTPLAY')).then((value) {});

      await Stripe.instance.presentPaymentSheet().then((value) => {
       print("Payment Sheet Displayed Successfully!"),
      } 
      );
      }catch (e) {
        throw Exception(e);
      }
  }}
  /*void payFee() {
    try {
      // Display a toast message when payFee is called
      Fluttertoast.showToast(
        msg: 'Payment fee processed!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // You can add your payment fee logic here if needed
    } catch (e) {
      // Handle exceptions during payment fee processing
      Fluttertoast.showToast(
        msg: 'Error processing payment fee: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


   Future<void> makePayment() async {
    try {
      print("Making payment...");
      paymentIntentData =
          await createPaymentIntent(money, 'MYR'); //json.decode(response.body);
      print("Payment Intent Data: $paymentIntentData");
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'SPORTPLAY'))
          .then((value) {});
      displayPaymentSheet();
    } catch (e, s) {
      print("Error during payment: $e");
      if (kDebugMode) {
        print(s);
      }
    }
  }

   Future<void> displayPaymentSheet() async {
    try {
      print("Displaying Payment Sheet...");

      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Payment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'You are about to make a payment of RM $money.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    
                    Navigator.pop(context);

                    // Proceed with the payment
                    await Stripe.instance.presentPaymentSheet();
                    
                    // Call payFee after payment sheet is presented
                    payFee();

                    Fluttertoast.showToast(
                      msg: 'Payment successfully completed',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                    print("Payment Sheet Displayed Successfully!");
                  },
                  child: Text('Confirm Payment'),
                ),
              ],
            ),
          );
        },
      );

    } on StripeException catch (e) {
      print("Stripe Exception: $e");
      Fluttertoast.showToast(
        msg: 'Error from Stripe: ${e.error.localizedMessage}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error during payment: $e");
      Fluttertoast.showToast(
        msg: 'Unforeseen error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': 'MYR',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
            'Bearer sk_test_51OQ77jL9jiXabeNWIWpB3NvVkYun6KGfOlV7JBtkjDd1VpKyU8QI4ZSb2GtXcexsNYHZVI5Ii2avBL1ZVj2slMkB00VQ0wRdaZ',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}*/
 

