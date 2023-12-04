import 'package:flutter/material.dart';

void main() {
  runApp(QnASystem());
}

class QnASystem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q&A System',
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
    {'question': 'What is Flutter?', 'answer': 'Flutter is a UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.'},
    {'question': 'How to install Flutter?', 'answer': 'You can install Flutter by following the installation guide on the official Flutter website: https://flutter.dev/docs/get-started/install'},
    // Add more questions and answers as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q&A System'),
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
