import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportplays/model/bookingdetails.dart';
import 'package:sportplays/model/user.dart';

class ViewBookingDetailsAdminPage extends StatefulWidget {
  final User passUser;

  const ViewBookingDetailsAdminPage({
    Key? key,
    required this.passUser,
  }) : super(key: key);

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
    try {
      DateTime currentDate = DateTime.now();
      DateTime startOfDay =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('Booking')
              .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
              .where('timestamp', isLessThan: endOfDay)
              .get();

      print('Number of documents for today: ${querySnapshot.docs.length}');

      List<Booking> bookings = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Booking(
          bookingId: data['bookingId'],
          selectedActivity: data['selectedActivity'],
          playerQuantity: data['playerQuantity'],
          selectedPaymentMethod: data['selectedPaymentMethod'],
          selectedTime: data['selectedTime'],
          timestamp: data['timestamp'],
          userName: data['userName'],
          isCourtAssigned: data.containsKey('isCourtAssigned')
              ? data['isCourtAssigned']
              : false,
        );
      }).toList();

      // Sort the bookings based on timestamp in descending order
      bookings.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

      print('Number of bookings for today: ${bookings.length}');
      print(
          'First booking timestamp for today: ${bookings.isNotEmpty ? bookings.first.timestamp : 'No bookings for today'}');

      return bookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Widget _buildListView(List<Booking> bookings) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        Booking booking = bookings[index];

        // Check if court is assigned and set color accordingly
        Color tileColor =
            booking.isCourtAssigned ?? false ? Colors.green : Colors.red;

        return Card(
          color: tileColor, // Set tile color
          child: ListTile(
            title: Text(
                'Player: ${booking.userName}'), // Display user name from Firestore
            subtitle: Text(
                'Sport: ${booking.selectedActivity}'), // Display sport name in subtitle
            onTap: () {
              _showBookingDetailsDialog(booking);
            },
          ),
        );
      },
    );
  }

  Future<void> _showBookingDetailsDialog(Booking booking) async {
  String assignCourtValue = booking.isCourtAssigned ?? false
      ? 'Assigned'
      : 'Not Assigned';

  Color dialogColor =
      assignCourtValue == 'Assigned' ? Colors.green : Colors.red;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Booking Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Booking ID: ${booking.bookingId}'),
                Text('Player: ${booking.userName}'),
                Text('Sport: ${booking.selectedActivity}'),
                Text('Players: ${booking.playerQuantity}'),
                Text('Payment Method: ${booking.selectedPaymentMethod}'),
                Text('Selected Time: ${booking.selectedTime}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Assign Court: '),
                    DropdownButton<String>(
                      value: assignCourtValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          assignCourtValue = newValue!;
                          dialogColor =
                              assignCourtValue == 'Assigned' ? Colors.green : Colors.red;
                        });
                      },
                      items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', 'Not Assigned']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    booking.isCourtAssigned = assignCourtValue == 'Assigned';
                  });

                  await FirebaseFirestore.instance
                      .collection('Booking')
                      .doc(booking.bookingId.toString())
                      .update({'isCourtAssigned': booking.isCourtAssigned});
                  Navigator.pop(context);
                  _refreshPage();
                },
                child: Text('Save'),
              ),
            ],
            backgroundColor: dialogColor,
          );
        },
      );
    },
  );
}


  void _refreshPage() {
  setState(() {});
}
}
