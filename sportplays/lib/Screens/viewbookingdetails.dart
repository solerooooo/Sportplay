import 'package:flutter/material.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Screens/editbookingdetails.dart';
import 'home.dart';
import '../models/user.dart';
import 'qna.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBookingPage extends StatefulWidget {
  final User passUser;

  const ViewBookingPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _ViewBookingPageState createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  int _selectedIndex = 0;

  List<Booking> bookings = []; // Initialize an empty list

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('View Booking Details'),
          backgroundColor: Colors.lightGreenAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Past'),
              Tab(text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(_getUpcomingBookings()),
            _buildTabContent(_getPastBookings()),
          ],
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
      ),
    );
  }

  Widget _buildTabContent(List<Booking> filteredBookings) {
    return Container(
      color: const Color(0xFFb364f3), // Set the desired background color
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Activity ${filteredBookings[index].userName}'),
                  subtitle: Text(
                    'Time: ${filteredBookings[index].startTime} - ${filteredBookings[index].endTime}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _redirectToEditPage(filteredBookings[index]);
                    },
                  ),
                  onTap: () {
                    _showBookingDetails(filteredBookings[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Booking> _getUpcomingBookings() {
    final now = DateTime.now();
    return bookings
        .where((booking) =>
            booking.startTime.isAfter(now) || booking.endTime.isAfter(now))
        .toList();
  }

  List<Booking> _getPastBookings() {
    final now = DateTime.now();
    return bookings
        .where((booking) =>
            booking.endTime.isBefore(now) && booking.startTime.isBefore(now))
        .toList();
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Activity: ${booking.userName}'),
              Text('Time Slot: ${booking.startTime}'),
              Text('End Time: ${booking.endTime}'),
            ],
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

  void _redirectToEditPage(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditBookingDetailsPage(passUser: widget.passUser, selectedTime: '', bookingId: '',),
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
            (doc['startTime'] as Timestamp).toDate(),
            (doc['endTime'] as Timestamp).toDate(),
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
