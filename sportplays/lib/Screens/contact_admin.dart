// contact_admin.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/contact_info.dart'; // Adjust the import based on your project structure

class ContactAdmin extends StatefulWidget {
  @override
  _ContactAdminState createState() => _ContactAdminState();
}

class _ContactAdminState extends State<ContactAdmin> {
  final CollectionReference contactCollection =
      FirebaseFirestore.instance.collection('contacts');

  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> addContact() async {
    try {
      await contactCollection.add({
        'name': nameController.text,
        'position': positionController.text,
        'phone': phoneController.text,
      });

      // Clear the text controllers after adding a contact
      nameController.clear();
      positionController.clear();
      phoneController.clear();
    } catch (e) {
      // Handle errors during the add operation
      print('Error adding contact: $e');
    }
  }

  Future<void> deleteContact(String docId) async {
    try {
      await contactCollection.doc(docId).delete();
    } catch (e) {
      // Handle errors during the delete operation
      print('Error deleting contact: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFE6DFF1),
      appBar: AppBar(
        backgroundColor: Color(0xFFb364f3), 
        elevation: 0,
        title: Text('Admin Contacts'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Contact:'),
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
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addContact,
                child: Text('Add Contact'),
              ),
              SizedBox(height: 30),
              Text('Existing Contacts:'),
              StreamBuilder(
                stream: contactCollection.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text('${data['position']} ${data['phone']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteContact(document.id),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
