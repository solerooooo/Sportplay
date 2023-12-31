import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/model/bookingdetails.dart';
import 'package:sportplays/screen/booking.dart';
import 'package:sportplays/screen/editbookingdetails.dart';
import 'package:sportplays/screen/home.dart';
import 'package:sportplays/screen/profile.dart';
import 'package:sportplays/screen/qna.dart';
import 'package:sportplays/model/user.dart';
import 'package:intl/intl.dart';


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

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(
              passUser: widget.passUser,
              selectedTime: '',
              selectedActivity: '',
              timestamp: null,
            ),
          ),
        );
        break;
      case 1:
        // Current ViewBooking page, no need to navigate
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

  Future<List<Booking>> _getBookings() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
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
        isCourtAssigned: false,
        timestamp: doc['timestamp'],
      );
    }).toList();

    return bookings;
  }

 Widget _buildListView(List<Booking> bookings) {
  return ListView.builder(
    itemCount: bookings.length,
    itemBuilder: (context, index) {
      Booking booking = bookings[index];
      DateTime? bookingDate = booking.timestamp?.toDate(); // Add null check with '?'

      return Card(
        child: ListTile(
          title: Text('Activity: ${booking.selectedActivity}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Players: ${booking.selectedTime}'),
              Text('Booking Date: ${bookingDate != null ? DateFormat.yMd().add_jm().format(bookingDate) : "N/A"}'),
            ],
          ),
          onTap: () {
            _showBookingDetailsDialog(booking);
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBookingDetailsPage(
                        passUser: widget.passUser,
                        bookingId: booking.bookingId,
                        selectedTime: booking.selectedTime,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmationDialog(booking);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}



  void _deleteBooking(Booking booking) async {
    await FirebaseFirestore.instance
        .collection('Booking')
        .doc('${booking.bookingId}')
        .delete();
    _showDeletedConfirmationDialog();
  }

  Future<void> _showDeleteConfirmationDialog(Booking booking) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the delete confirmation dialog
                _deleteBooking(booking);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the delete confirmation dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletedConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Deleted'),
          content: Text('Your booking has been successfully deleted!'),
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
