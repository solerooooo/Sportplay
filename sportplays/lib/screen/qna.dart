import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'booking.dart';
import 'home.dart';
import 'viewbookingdetails.dart';
import 'profile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class QnAService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getQnAStream() {
    return _firestore.collection('qna').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'question': data['question'],
          'answer': data['answer'],
          'documentId': doc.id,
        };
      }).toList();
    });
  }
}

class QnAPage extends StatefulWidget {
  final User passUser;

  const QnAPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  int _selectedIndex = 3; // Set the initial index to 3 for Q&A

  final QnAService _qnAService = QnAService();

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewBookingPage(
              passUser: widget.passUser,
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
        // Current Q&A page, no need to navigate
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

  @override
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
        activeColor: CupertinoColors.black,
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
   
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Frequently Asked Questions'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      backgroundColor: Color(0xFFE6DFF1),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _qnAService.getQnAStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> qnaList = snapshot.data ?? [];

            return ListView.builder(
              itemCount: qnaList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(qnaList[index]['question']),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(qnaList[index]['answer']),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
