import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'home.dart';
import '../models/user.dart';
import 'viewbookingdetails.dart';
import 'profile.dart';
import 'qna.dart';

class QnAAdmin extends StatefulWidget {
  final User passUser;

  const QnAAdmin({Key? key, required this.passUser}) : super(key: key);

  @override
  _QnAAdminState createState() => _QnAAdminState();
}

class _QnAAdminState extends State<QnAAdmin> {
  int _selectedIndex = 0;
  List<Map<String, String>> qnaList = [
    {
      'question': 'What are the available payment methods?',
      'answer': 'Pay for your bookings using any of the following supported payment options: FPX Online Banking or Cash'
    },
    {
      'question': 'How can I view my booking details?',
      'answer': '1. Click on your Profile page. 2. Click on the History button. 3. You’ll be able to view the details of your booking, including the date and time of your booking.'
    },
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addQnA(String question, String answer) async {
    try {
      await _firestore.collection('qna').add({
        'question': question,
        'answer': answer,
      });
    } catch (e) {
      print('Error adding Q&A: $e');
    }
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

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewBookingPage(passUser: widget.passUser),
        ),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QnAAdmin(passUser: widget.passUser),
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
        title: Text('Insights'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: ListView.builder(
        itemCount: qnaList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(qnaList[index]['question']!),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(qnaList[index]['answer']!),
                ),
              ],
            ),
          );
        },
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
            label: 'View Booking',
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
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                // Replace with your logic to get user input for question and answer
                String question = 'How do I add a new question?';
                String answer = 'To add a new question, follow the steps...';

                addQnA(question, answer);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
