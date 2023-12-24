import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/models/bookingdetails.dart';

class ViewBookingDetailsAdminPage extends StatefulWidget {
  const ViewBookingDetailsAdminPage({Key? key});

  @override
  _ViewBookingDetailsAdminPageState createState() =>
      _ViewBookingDetailsAdminPageState();
}

class _ViewBookingDetailsAdminPageState
    extends State<ViewBookingDetailsAdminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: FutureBuilder(
        future: _getAllBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Booking> bookings = snapshot.data as List<Booking>;
            return _buildListView(bookings);
          }
        },
      ),
    );
  }

  Future<List<Booking>> _getAllBookings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('Booking').get();

    List<Booking> bookings = querySnapshot.docs.map((doc) {
      return Booking(
        bookingId: doc['bookingId'],
        selectedActivity: doc['selectedActivity'],
        playerQuantity: doc['playerQuantity'],
        selectedPaymentMethod: doc['selectedPaymentMethod'],
        selectedTime: doc['selectedTime'],
      );
    }).toList();

    return bookings;
  }

  Widget _buildListView(List<Booking> bookings) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        Booking booking = bookings[index];
        return Card(
          child: ListTile(
              title: Text('Activity: ${booking.selectedActivity}'),
              subtitle: Text('Players: ${booking.selectedTime}'),
              onTap: () {
                _showBookingDetailsDialog(booking);
              }),
        );
      },
    );
  }

  Future<void> _showBookingDetailsDialog(Booking booking) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Booking ID: ${booking.bookingId}'),
              Text('Activity: ${booking.selectedActivity}'),
              Text('Players: ${booking.playerQuantity}'),
              Text('Payment Method: ${booking.selectedPaymentMethod}'),
              Text('Selected Time: ${booking.selectedTime}'),
              // Add other fields as needed
            ],
          ),
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
}
