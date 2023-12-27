import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportplays/Screens/login.dart';
import 'profile.dart';
import '../models/user.dart';
import 'booking.dart';
import 'viewbookingdetails.dart';
import 'qna.dart';
import 'contact.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final User passUser;

  Home({Key? key, required this.passUser}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewBookingPage(
            passUser: widget.passUser,
          ),
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

    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactPage(), // Navigate to ContactPage
        ),
      );
    }
  }

  void _logout() {
    // Navigate to the login page and clear all routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFb364f3), Color(0xFFD6F454)],
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xFFE6DFF1),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFb364f3).withOpacity(0.5),
                  image: DecorationImage(
                    image: AssetImage('images/sporthall.png'),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.dstATop,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(passUser: widget.passUser),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Booking Page'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingPage(
                        passUser: widget.passUser,
                        selectedTime: 'Choose your time slot',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('View Booking Details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewBookingPage(passUser: widget.passUser),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Contact'), // Add Contact to the drawer
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactPage(),
                    ),
                  );
                },
              ),
              Spacer(), // Add Spacer to push the logout button to the bottom
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout), // Add the logout icon
                onTap: _logout,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFFE6DFF1),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Welcome, ${widget.passUser.getName()}!',
                          style: GoogleFonts.notoSerif(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 40),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('news')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            List<QueryDocumentSnapshot> newsList =
                                snapshot.data!.docs;

                            return SizedBox(
                              height: 200,
                              child: PageView.builder(
                                itemCount: newsList.length,
                                controller:
                                    PageController(viewportFraction: 0.87),
                                itemBuilder: (context, index) {
                                  DateTime newsDate =
                                      (newsList[index]['date'] as Timestamp)
                                          .toDate();

                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 400,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  newsList[index]['title'],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                      newsList[index]
                                                          ['contents'],
                                                      style: TextStyle(
                                                          fontSize: 15.0),
                                                      textAlign:
                                                          TextAlign.justify,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Posted Date: ${newsDate.day}/${newsDate.month}/${newsDate.year}',
                                                  style:
                                                      TextStyle(fontSize: 12.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 320,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Color(0xFF444444),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Want to book a court?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 250, // Adjust the width as needed
                          height: 60, // Adjust the height as needed
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingPage(
                                    passUser: widget.passUser,
                                    selectedTime: 'Choose your time slot',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD6F454),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.black.withOpacity(0.5),
                              elevation: 5,
                            ),
                            child: Text(
                              'Book Now',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularButton(
                          icon: Icons.home,
                          label: 'Home',
                          onPressed: () {
                            // Navigate to Home
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Home(passUser: widget.passUser),
                              ),
                            );
                          },
                        ),
                        _buildCircularButton(
                          icon: Icons.add,
                          label: 'Booking',
                          onPressed: () {
                            // Navigate to BookingPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingPage(
                                  passUser: widget.passUser,
                                  selectedTime: 'Choose your time slot',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildCircularButton(
                          icon: Icons.question_answer,
                          label: 'Q&A',
                          onPressed: () {
                            // Navigate to QnAPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QnAPage(passUser: widget.passUser),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularButton(
                          icon: Icons.contact_mail,
                          label: 'Contact',
                          onPressed: () {
                            // Navigate to ContactPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactPage(),
                              ),
                            );
                          },
                        ),
                        _buildCircularButton(
                          icon: Icons.person,
                          label: 'Profile',
                          onPressed: () {
                            // Navigate to Profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Profile(passUser: widget.passUser),
                              ),
                            );
                          },
                        ),
                        _buildCircularButton(
                          icon: Icons.book_rounded,
                          label: 'Booking details',
                          onPressed: () {
                            // Navigate to ViewBookingPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewBookingPage(passUser: widget.passUser),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 80,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFb364f3), Color(0xFFD6F454)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: MaterialButton(
              onPressed: onPressed,
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
