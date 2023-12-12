import 'package:flutter/material.dart';
import 'package:sportplays/Models/bookingdetails.dart';
import 'package:sportplays/Screens/editbookingdetails.dart';

void main() {
  runApp(ViewBookingApp());
}

class ViewBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Booking Details',
      home: ViewBookingPage(),
    );
  }
}

class ViewBookingPage extends StatefulWidget {
  @override
  _ViewBookingPageState createState() => _ViewBookingPageState();
}

class _ViewBookingPageState extends State<ViewBookingPage> {
  List<Booking> bookings = [
    Booking('John Doe', 'Squash Court', DateTime(2023, 11, 1, 14, 30),
        DateTime(2023, 11, 1, 16, 30)),
    Booking('Jane Smith', 'Badminton', DateTime(2023, 11, 2, 10, 0),
        DateTime(2023, 11, 2, 12, 0)),
    // Add more booking instances as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Booking Details'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          _buildBookingList("Upcoming", _getUpcomingBookings()),
          _buildBookingList("Past", _getPastBookings()),
        ],
      ),
    );
  }

  Widget _buildBookingList(String title, List<Booking> filteredBookings) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Booking by ${filteredBookings[index].userName}'),
                  subtitle: Text(
                      'Facility: ${filteredBookings[index].facility}\nTime: ${filteredBookings[index].startTime} - ${filteredBookings[index].endTime}'),
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
    return bookings.where((booking) => booking.startTime.isAfter(now)).toList();
  }

  List<Booking> _getPastBookings() {
    final now = DateTime.now();
    return bookings.where((booking) => booking.endTime.isBefore(now)).toList();
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
              Text('User: ${booking.userName}'),
              Text('Facility: ${booking.facility}'),
              Text('Start Time: ${booking.startTime}'),
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
        builder: (context) => EditBookingDetailsPage(booking: booking),
      ),
    );
  }
}
