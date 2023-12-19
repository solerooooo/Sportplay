import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactInfoApp extends StatefulWidget {
  ContactInfoApp({Key? key}) : super(key: key);

  @override
  State<ContactInfoApp> createState() => _ContactInfoAppState();
}

class _ContactInfoAppState extends State<ContactInfoApp> {
  final CollectionReference contactsCollection =
      FirebaseFirestore.instance.collection('contacts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color(0xFFb364f3),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE6DFF1),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Container(
                color: Color(0xFFE6DFF1),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Contact Info',
                      style: GoogleFonts.notoSerif(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: contactsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<Widget> contactWidgets = snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;

                        return Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                data['position'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              Text(
                                data['phone'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                      })
                      .toList();

                  return Column(children: contactWidgets);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
