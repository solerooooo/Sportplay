import 'package:flutter/cupertino.dart';
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
  int _selectedIndex = 1;

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
        break;
    }
  }

  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
          ),
        ],
        activeColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _selectedPage();
          },
        );
      },
    );
  }

  Widget _selectedPage() {
    switch (_selectedIndex) {
      case 0:
        return Container(); // This is just a placeholder since the page is handled in _onTabSelected
      case 1:
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('My Bookings'),
            backgroundColor: Colors.lightGreenAccent,
          ),
          backgroundColor: Color(0xFFE6DFF1),
          child: FutureBuilder(
            future: _getBookings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Booking> bookings = snapshot.data as List<Booking>;
                return _buildListView(bookings);
              }
            },
          ),
        );
      case 2:
        return Container(); // This is just a placeholder since the page is handled in _onTabSelected
      case 3:
        return Container(); // This is just a placeholder since the page is handled in _onTabSelected
      case 4:
        return Container(); // This is just a placeholder since the page is handled in _onTabSelected
      default:
        return Container();
    }
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
        DateTime? bookingDate = booking.timestamp?.toDate();

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
                  icon: Icon(CupertinoIcons.pencil),
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
                  icon: Icon(CupertinoIcons.trash),
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
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this booking?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _deleteBooking(booking);
              },
              child: Text('Yes'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeletedConfirmationDialog() async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Booking Deleted'),
          content: Text('Your booking has been successfully deleted!'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBookingDetailsDialog(Booking booking) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
