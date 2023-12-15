import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sportplays/Screens/availability_admin.dart';
import 'login.dart';
import 'profile.dart';
import 'register.dart';
import '../models/user.dart';
import 'booking.dart';
import 'qna.dart';

class HomeAdmin extends StatefulWidget {
  final User passUser;
  HomeAdmin({Key? key, required this.passUser}) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _selectedIndex = 0;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingPage(
            passUser: widget.passUser,
            selectedTime: 'YourSelectedTimeHere',
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
  }

  void _addNews() async {
    CollectionReference newsCollection =
        FirebaseFirestore.instance.collection('news');

    DateTime currentDate = DateTime.now();

    await newsCollection.doc(_titleController.text).set({
      'title': _titleController.text,
      'contents': _contentsController.text,
      'date': currentDate, // Add the date field
    });

    _titleController.clear();
    _contentsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage (ADMIN)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
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
              title: Text('Booking Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingPage(
                      passUser: widget.passUser,
                      selectedTime: 'YourSelectedTimeHere',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFb364f3), Color(0xFFD6F454)],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'haa kerja, ${widget.passUser.getName()}!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 600,
                child: Column(
                  children: [
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
                                    decoration:
                                        InputDecoration(labelText: 'Title'),
                                  ),
                                  TextField(
                                    controller: _contentsController,
                                    decoration:
                                        InputDecoration(labelText: 'Contents'),
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
                                  child: Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Add News'),
                    ),
                    // Existing code...

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
                            controller: PageController(viewportFraction: 0.87),
                            itemBuilder: (context, index) {
                              DateTime newsDate =
                                  (newsList[index]['date'] as Timestamp)
                                      .toDate();

                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: 400,
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                                                decoration: TextDecoration.underline,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 10),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Text(
                                                  newsList[index]['contents'],
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Date: ${newsDate.day}/${newsDate.month}/${newsDate.year}',
                                              style: TextStyle(fontSize: 12.0),
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
                      width: 300,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'Update the time slot',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AvailabilityAdminPage(
                                    passUser: widget.passUser,
                                  ),
                                ),
                              );
                            },
                            child: Text('Go to Availability Page'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'images/sporthall.png',
                      height: 180,
                      width: 600,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        showUnselectedLabels: true,
        items: [
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

  void _deleteNews(String documentId) async {
    CollectionReference newsCollection =
        FirebaseFirestore.instance.collection('news');

    await newsCollection.doc(documentId).delete();
  }
}
