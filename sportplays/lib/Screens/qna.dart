//qna.dart
import 'package:flutter/material.dart';
import 'home.dart';
import '../models/user.dart';
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
  int _selectedIndex = 0;
  List<Map<String, dynamic>> qnaList = [];

  final QnAService _qnAService = QnAService();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Current Booking page, no need to navigate
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

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _qnAService.getQnAStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            qnaList = snapshot.data ?? [];

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'View Booking',
          ),
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
}