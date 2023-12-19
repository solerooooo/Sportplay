import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Screens/contact.dart'; // Import your existing contact_info.dart file

class ContactAdmin extends StatefulWidget {
  @override
  _ContactAdminState createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  CollectionReference contacts = FirebaseFirestore.instance.collection('contacts');

  Future<void> addContact() async {
    await contacts.add({
      'name': nameController.text,
      'title': titleController.text,
      'phone': phoneController.text,
    });

    Fluttertoast.showToast(msg: 'Contact added successfully');
  }

  Future<void> deleteContact(DocumentSnapshot contact) async {
    await contacts.doc(contact.id).delete();

    Fluttertoast.showToast(msg: 'Contact deleted successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addContact,
              child: Text('Add Contact'),
            ),
            SizedBox(height: 16),
            Text(
              'Existing Contacts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder(
                stream: contacts.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot contact = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(contact['name']),
                        subtitle: Text(contact['title']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteContact(contact),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
