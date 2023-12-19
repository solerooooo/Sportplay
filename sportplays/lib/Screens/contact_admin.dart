import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactInfoApp extends StatefulWidget {
  ContactInfoApp({Key? key}) : super(key: key);

  @override
  State<ContactInfoApp> createState() => _ContactInfoAppState();
}

class _ContactInfoAppState extends State<ContactInfoApp> {
  final CollectionReference adminContacts =
      FirebaseFirestore.instance.collection('admin_contacts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFb364f3),
        elevation: 0,
      ),
      backgroundColor: Color(0xFFE6DFF1),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: adminContacts.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var contacts = snapshot.data!.docs;
              return Center(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    var contact = contacts[index].data() as Map<String, dynamic>;
                    return buildContactCard(contact);
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildContactCard(Map<String, dynamic> contact) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contact['name'],
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            contact['position'],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            contact['phone'],
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<void> _showAddContactDialog() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController positionController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Admin Contact'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: positionController,
                decoration: InputDecoration(labelText: 'Position'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
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
                _saveContactToFirestore(
                  nameController.text,
                  positionController.text,
                  phoneController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveContactToFirestore(
      String name, String position, String phone) async {
    try {
      await adminContacts.add({
        'name': name,
        'position': position,
        'phone': phone,
      });
      print('Admin contact added to Firestore successfully!');
    } catch (e) {
      print('Error adding admin contact to Firestore: $e');
    }
  }
}
