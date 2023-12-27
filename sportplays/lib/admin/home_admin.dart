import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportplays/admin/availability_admin.dart';
import 'package:sportplays/admin/contact_admin.dart';
import 'package:sportplays/admin/qna_admin.dart';
import 'package:sportplays/admin/viewbookingdetails_admin.dart';
import '../screens/login.dart';
import '../screens/profile.dart';
import '../screens/register.dart';
import '../models/user.dart';
import '../screens/booking.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAdmin extends StatefulWidget {
  final User passUser;
  HomeAdmin({Key? key, required this.passUser}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  void _addNews() async {
    CollectionReference newsCollection =
        FirebaseFirestore.instance.collection('news');

    DateTime currentDate = DateTime.now();

    await newsCollection.doc(_titleController.text).set({
      'title': _titleController.text,
      'contents': _contentsController.text,
      'date': currentDate,
    });

    _titleController.clear();
    _contentsController.clear();

    // Show notification
    //Notifications.showNewsAddedNotification(_titleController.text);
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
                title: Text('Login'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
              ListTile(
                title: Text('Register'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(
                        firestore: FirebaseFirestore.instance,
                      ),
                    ),
                  );
                },
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
                title: Text('Contact'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactAdminPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('QnA'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QnAAdmin(
                        passUser: widget.passUser,
                      ),
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
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Welcome, ${widget.passUser.getName()}!',
                  style: GoogleFonts.notoSerif(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 600,
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Add News'),
                                    content: Column(
                                      children: [
                                        TextField(
                                          controller: _titleController,
                                          decoration: InputDecoration(
                                              labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: _contentsController,
                                          decoration: InputDecoration(
                                              labelText: 'Contents'),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _addNews();
                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF444444),
                                        ),
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF444444),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Color(0xFFC9DB7E),
                                  size: 20, // Adjust the size as needed
                                ),
                                Text(
                                  ' Add',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 10),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('news')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      borderRadius: BorderRadius.circular(10.0),
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    newsList[index]['contents'],
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Date: ${newsDate.day}/${newsDate.month}/${newsDate.year}',
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              _deleteNews(newsList[index].id);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
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
                                'Update the time slot',
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
                                        builder: (context) =>
                                            AvailabilityAdminPage(
                                          passUser: widget.passUser,
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
                                    'Go to Availability Page',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 400,
                        height: 250, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCircularButton(
                                  icon: Icons.home,
                                  label: 'Home',
                                  onPressed: () {
                                    // Navigate to home_admin.dart
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeAdmin(
                                            passUser: widget.passUser),
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
                                            QnAAdmin(passUser: widget.passUser),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                  icon: Icons.contact_phone,
                                  label: 'Contacts',
                                  onPressed: () {
                                    // Navigate to ContactAdmin
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactAdminPage(),
                                      ),
                                    );
                                  },
                                ),
                                _buildCircularButton(
                                  icon: Icons.auto_awesome_outlined,
                                  label: 'View Booking Details',
                                  onPressed: () {
                                    // Navigate to ContactAdmin
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewBookingDetailsAdminPage(passUser: widget.passUser),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  void _deleteNews(String documentId) async {
    CollectionReference newsCollection =
        FirebaseFirestore.instance.collection('news');

    await newsCollection.doc(documentId).delete();
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
