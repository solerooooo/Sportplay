import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../screens/home.dart';
import '../models/user.dart';
import '../screens/viewbookingdetails.dart';
import '../screens/profile.dart';
import '../screens/qna.dart';

class QnAAdmin extends StatefulWidget {
  final User passUser;

  const QnAAdmin({Key? key, required this.passUser}) : super(key: key);

  @override
  _QnAAdminState createState() => _QnAAdminState();
}

class _QnAAdminState extends State<QnAAdmin> {
  int _selectedIndex = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  List<Map<String, dynamic>> qnaList = [];

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

  Future<void> addQnA(String question, String answer) async {
    try {
      await _firestore.collection('qna').doc(question).set({
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
          builder: (context) => ViewBookingPage(passUser: widget.passUser,),
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

  void _showAddQnAPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Q&A'),
          content: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(labelText: 'Answer'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
              
                String question = _questionController.text.trim();
                String answer = _answerController.text.trim();
                if (question.isNotEmpty && answer.isNotEmpty) {
                  addQnA(question, answer);
                  _questionController.clear();
                  _answerController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
        backgroundColor: Colors.lightGreenAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddQnAPopup();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteQnAList();
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFE6DFF1),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getQnAStream(),
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
                  color: Color(0xFF444444), // Set the background color here
                  child: ExpansionTile(
                    title: Text(
                      qnaList[index]['question'],
                      style: TextStyle(color: Colors.white), // Set text color
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          qnaList[index]['answer'],
                          style: TextStyle(color: Colors.white), // Set text color
                        ),
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


  void _showDeleteQnAList() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Q&A to Delete'),
          content: Column(
            children: List.generate(
              qnaList.length,
              (index) {
                return ListTile(
                  title: Text(qnaList[index]['question']),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteQnA(qnaList[index]['documentId']);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteQnA(String documentId) async {
    try {
      await _firestore.collection('qna').doc(documentId).delete();
    } catch (e) {
      print('Error deleting Q&A: $e');
    }
  }
}
