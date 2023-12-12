// setting.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class Setting extends StatefulWidget {
  final User passUser;
  final Function(User) onUpdateUser;

  const Setting({Key? key, required this.passUser, required this.onUpdateUser}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late User user;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = widget.passUser;
    emailController.text = user.getEmail();
    phoneController.text = user.getPhone();
    addressController.text = user.getAddress();
    genderController.text = user.getGender();
  }

  void saveChanges() async {
    final updatedUser = User(
      name: user.getName(),
      email: emailController.text,
      password: user.getPassword(),
      phone: phoneController.text,
      address: addressController.text,
      gender: genderController.text,
      userId: user.getId(),
    );

    // Update user data in Firebase
    await updateUserDataInFirebase(updatedUser);

    // Call the callback function to handle the updated user
    widget.onUpdateUser(updatedUser);
  }

  Future<void> updateUserDataInFirebase(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.getId()).set({
        'name': user.getName(),
        'email': user.getEmail(),
        'password': user.getPassword(),
        'phone': user.getPhone(),
        'address': user.getAddress(),
        'gender': user.getGender(),
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.amber,
                ),
                const SizedBox(height: 10),
                Text(
                  '${user.getName()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 21.5),
                ),
                Text(
                  '${user.getId()}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.lightGreenAccent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      'Active Student',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'About',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildTextField(Icons.person, 'Email', emailController),
                      const SizedBox(height: 20),
                      buildTextField(Icons.phone, 'Phone Number', phoneController),
                      const SizedBox(height: 20),
                      buildTextField(Icons.home, 'Address', addressController),
                      const SizedBox(height: 20),
                      buildTextField(Icons.work, 'Gender', genderController),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveChanges,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
