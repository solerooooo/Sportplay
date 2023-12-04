import 'package:flutter/material.dart';

void main() {
  runApp(QnASystem());
}

class QnASystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INSIGHTS',
      home: QnAPage(),
      theme: ThemeData(
        primaryColor: Colors.purple, // Set the primary color to purple
      ),
    );
  }
}

class QnAPage extends StatefulWidget {
  @override
  _QnAPageState createState() => _QnAPageState();
}

class _QnAPageState extends State<QnAPage> {
  List<Map<String, String>> qnaList = [
    {'question': 'What are the available payment methods?', 'answer': 'Pay for your bookings using any of the following supported payment options: FPX Online Banking or Cash'},
    {'question': 'How can I view my booking details?', 'answer': '1. Click on your Profile page. 2. Click on the History button.  3. You’ll be able to view the details of your booking, including the date and time of your booking.'},
    // Add more questions and answers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INSIGHTS'),
        // Set the background color of the AppBar to purple
        backgroundColor: Colors.purple,
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
    );
  }
}
