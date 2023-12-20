//qna.dart
import 'package:flutter/material.dart';
import 'home.dart';
import '../models/user.dart';
import 'viewbookingdetails.dart';
import 'profile.dart';


class QnAPage extends StatefulWidget {
  final User passUser;

  const QnAPage({Key? key, required this.passUser}) : super(key: key);
  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  int _selectedIndex = 0;
  List<Map<String, String>> qnaList = [
    {
      'question': 'What are the available payment methods?',
      'answer':
          'Pay for your bookings using any of the following supported payment options: FPX Online Banking or Cash'
    },
    {
      'question': 'How can I view my booking details?',
      'answer':
          '1. Click on your Profile page. 2. Click on the History button.  3. You’ll be able to view the details of your booking, including the date and time of your booking.'
    },
    // Add more questions and answers as needed
  ];
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
          builder: (context) => ViewBookingPage(passUser: widget.passUser,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
        // Set the background color of the AppBar to purple
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
    );
  }
}
