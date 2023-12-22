/*import 'package:flutter/material.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Screens/editbookingdetails.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBookingDetailsAdmin extends StatefulWidget {
  const ViewBookingDetailsAdmin({Key? key}) : super(key: key);

  @override
  _ViewBookingDetailsAdminState createState() => _ViewBookingDetailsAdminState();
}

class _ViewBookingDetailsAdminState extends State<ViewBookingDetailsAdmin> {
  int _selectedIndex = 0;

  List<Booking> bookings = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchAllBookingsFromFirestore();
  }

  void _onTabSelected(int index) {
    // Implement navigation logic if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin View Booking Details'),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text('User: ${bookings[index].userName}'),
                subtitle: Text(
                  'Activity: ${bookings[index].selectedActivity}\n'
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
                _buildBookingDetail('User:', booking.userName),
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
          passUser: User(name: booking.userName),
          selectedTime: booking.selectedTime,
          bookingId: booking.bookingId,
        ),
      ),
    );
  }

  void _fetchAllBookingsFromFirestore() async {
    try {
      QuerySnapshot bookingSnapshot = await _firestore.collection('bookings').get();

      List<Booking> fetchedBookings = [];

      bookingSnapshot.docs.forEach((doc) {
        fetchedBookings.add(
          Booking(
            doc['selectedActivity'],
            doc['selectedTime'],
            (doc['timestamp'] as Timestamp).toDate(),
            (doc['timestamp'] as Timestamp).toDate(),
            userName: doc['userName'],
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
*/