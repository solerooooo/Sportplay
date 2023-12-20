import 'package:flutter/material.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Screens/editbookingdetails.dart';
import 'home.dart';
import '../models/user.dart';
import 'qna.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String selectedActivity;
  final String selectedTime;
  final DateTime startTime;
  final DateTime endTime;

  Booking(this.selectedActivity, this.selectedTime, this.startTime, this.endTime);
}

class ViewBookingPage extends StatefulWidget {
  final User passUser;

  const ViewBookingPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _ViewBookingPageState createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  int _selectedIndex = 0;

  List<Booking> bookings = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchBookingsFromFirestore();
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
        title: Text('View Booking Details'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        color: const Color(0xFFb364f3),
        child: ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white, // You can set your desired background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text('Activity ${bookings[index].selectedActivity}'),
                subtitle: Text(
                  'Time: ${bookings[index].startTime} - ${bookings[index].endTime}',
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _redirectToEditPage(bookings[index]);
                  },
                ),
                onTap: () {
                  _showBookingDetails(bookings[index]);
                },
              ),
            );
          },
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

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBookingDetail('Activity:', booking.selectedActivity),
                _buildBookingDetail('Time Slot:', booking.startTime.toString()),
                _buildBookingDetail('End Time:', booking.endTime.toString()),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label'),
          SizedBox(width: 8.0),
          Expanded(
            child: Text('$value'),
          ),
        ],
      ),
    );
  }

  void _redirectToEditPage(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookingDetailsPage(
          passUser: widget.passUser,
          selectedTime: '',
          bookingId: '',
        ),
      ),
    );
  }

  void _fetchBookingsFromFirestore() async {
    try {
      String userName = widget.passUser.getName();
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .doc(userName)
          .collection('userBookings')
          .get();

      List<Booking> fetchedBookings = [];

      bookingSnapshot.docs.forEach((doc) {
        fetchedBookings.add(
          Booking(
            doc['selectedActivity'],
            doc['selectedTime'],
            (doc['timestamp'] as Timestamp).toDate(),
            (doc['timestamp'] as Timestamp).toDate(),
          ),
        );
      });

      setState(() {
        bookings = fetchedBookings;
      });
    } catch (e) {
      print('Error fetching bookings: $e');
    }
  }
}
