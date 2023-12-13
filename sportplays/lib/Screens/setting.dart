// setting.dart
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
  String selectedGender = '';

  @override
  void initState() {
    super.initState();
    user = widget.passUser;
    emailController.text = user.getEmail();
    phoneController.text = user.getPhone();
    addressController.text = user.getAddress();
    selectedGender = user.getGender();
  }

  void saveChanges() async {
    final updatedUser = User(
      name: user.getName(),
      email: emailController.text,
      password: user.getPassword(),
      phone: phoneController.text,
      address: addressController.text,
      gender: selectedGender,
      userId: user.getId(),
    );

    // Update user data in Firestore
    await updateUserDataInFirestore(updatedUser);

    // Call the callback function to handle the updated user
    widget.onUpdateUser(updatedUser);

    // Navigate back to the Profile page
    Navigator.pop(context);
  }

  Future<void> updateUserDataInFirestore(User user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.getId()).update({
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
      backgroundColor: const Color(0xFFb364f3),
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
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
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
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
                      buildGenderDropdown(),
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

  // setting.dart

// ...

Widget buildTextField(IconData icon, String label, TextEditingController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon),
      const SizedBox(width: 10),
      Expanded(
        child: SizedBox(
          width: 250, // Adjust the width as needed
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              prefixIcon: Icon(icon), // Add prefix icon
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildGenderDropdown() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.work),
      const SizedBox(width: 10),
      Expanded(
        child: SizedBox(
          width: 250, // Adjust the width as needed
          child: DropdownButtonFormField<String>(
            value: selectedGender,
            onChanged: (String? value) {
              setState(() {
                selectedGender = value!;
              });
            },
            items: ['Female', 'Male']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              prefixIcon: const Icon(Icons.work), // Add prefix icon
            ),
          ),
        ),
      ),
    ],
  );
}
}

