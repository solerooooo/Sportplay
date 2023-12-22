import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Screens/home.dart';
import 'package:sportplays/Screens/profile.dart';
import 'package:sportplays/Screens/qna.dart';
import 'package:sportplays/models/user.dart';

class ViewBookingPage extends StatefulWidget {
  final User passUser;

  const ViewBookingPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _ViewBookingPageState createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  int _selectedIndex = 0;

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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: FutureBuilder(
        future: _getBookings(),
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

  Future<List<Booking>> _getBookings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Booking')
            .where('userName', isEqualTo: widget.passUser.name)
            .get();

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
            },
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Handle edit action if needed
              },
            ),
          ),
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
