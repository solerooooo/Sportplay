import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/Screens/assigncourt.dart';

class ViewBookingDetailsAdmin extends StatefulWidget {
  @override
  _ViewBookingDetailsAdminState createState() =>
      _ViewBookingDetailsAdminState();
}

class _ViewBookingDetailsAdminState extends State<ViewBookingDetailsAdmin> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _fetchBookingDetails(String userName, String bookingId) async {
    try {
      DocumentSnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .doc(userName)
          .collection('userBookings')
          .doc(bookingId)
          .get();

      print('Booking details: ${bookingSnapshot.data()}');
    } catch (e) {
      print('Error fetching booking details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Booking Details (Admin)'),
        backgroundColor: const Color(0xFFD6F454),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('bookings').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No bookings available.'),
            );
          }

          List<DocumentSnapshot> bookings = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              String userName = bookings[index].id;

              return ListTile(
                title: Text('Name: $userName'),
                subtitle: FutureBuilder(
                  future: _firestore
                      .collection('bookings')
                      .doc(userName)
                      .collection('userBookings')
                      .doc(bookings[index].id)
                      .get(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    if (!snapshot.hasData) {
                      return Text('Error loading data');
                    }

                    Map<String, dynamic> userBookings = snapshot.data!.data() as Map<String, dynamic>;

                    return Text('Booking ID: ${userBookings['bookingId']}');
                  },
                ),
                onTap: () {
                  _showBookingDetails(bookings[index]);
                  _fetchBookingDetails(userName, bookings[index].id);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showBookingDetails(DocumentSnapshot booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Activity: ${booking['selectedActivity']}'),
              Text('Player Quantity: ${booking['playerQuantity']}'),
              Text('Payment Method: ${booking['selectedPaymentMethod']}'),
              Text('Time: ${booking['selectedTime']}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _redirectToAssignCourtPage(booking);
              },
              child: Text('Assign Court'),
            ),
          ],
        );
      },
    );
  }

  void _redirectToAssignCourtPage(DocumentSnapshot booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssignCourtPage(),
      ),
    );
  }
}
