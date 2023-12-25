import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Setting extends StatefulWidget {
  final User passUser;
  final Function(User) onUpdateUser;
  final FirebaseFirestore firestore;

  const Setting({
    Key? key,
    required this.passUser,
    required this.onUpdateUser,
    required this.firestore,
  }) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late User user;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String selectedGender = '';
  late String originalGender;
  File? _pickedImage;
  String get imageUrl => _pickedImage != null ? _pickedImage!.path : user.getProfilePictureUrl();

  @override
  void initState() {
    super.initState();
    user = widget.passUser;
    emailController.text = user.getEmail();
    phoneController.text = user.getPhone();
    addressController.text = user.getAddress();
    originalGender = user.getGender();
    selectedGender = originalGender;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _pickedImage = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadProfilePicture(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$fileName');

      await reference.putFile(imageFile);

      // Get the download URL
      String imageUrl = await reference.getDownloadURL();

      setState(() {
        // Update the user's profile picture URL
        user = user.copyWith(profilePictureUrl: imageUrl);
      });

      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      // Handle the error (e.g., show a message to the user)
      return null; // Return null to indicate an error
    }
  }

  void saveChanges() async {
    String? imageUrl;

    if (_pickedImage != null) {
      // Upload profile picture and get the download URL
      imageUrl = await _uploadProfilePicture(_pickedImage!);
    }

    final updatedUser = User(
      name: user.getName(),
      email: emailController.text,
      password: user.getPassword(),
      phone: phoneController.text,
      address: addressController.text,
      gender: selectedGender,
      userId: user.getId(),
      profilePictureUrl: imageUrl ?? '', // Use the uploaded image URL if available
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
      await widget.firestore.collection('UserData').doc(user.getName()).set({
        'name': user.getName(),
        'email': user.getEmail(),
        'password': user.getPassword(),
        'phone': user.getPhone(),
        'address': user.getAddress(),
        'gender': user.getGender(),
        'userId': user.getId(),
        'profilePictureUrl': imageUrl,
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: const Text('Settings'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildProfilePicture(), // Display the profile picture
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImageFromGallery();
                    },
                    child: const Text('Pick Image from Gallery '),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImageFromCamera();
                    },
                    child: const Text('Pick Image from Camera'),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickFile();
                    },
                    child: const Text('Pick File'),
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
                        const SizedBox(height: 10),
                        buildTextField(Icons.email, 'Email', emailController),
                        const SizedBox(height: 10),
                        buildTextField(Icons.phone, 'Phone Number', phoneController),
                        const SizedBox(height: 10),
                        buildTextField(Icons.home, 'Address', addressController),
                        const SizedBox(height: 10),
                        buildGenderDropdown(),
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
      ),
    );
  }

  Widget buildTextField(IconData icon, String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            width: 250,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
                prefixIcon: Icon(icon),
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
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            width: 250,
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
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfilePicture() {
    if (_pickedImage != null) {
      return Image.file(
        _pickedImage!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (user.getProfilePictureUrl().isNotEmpty) {
      return Image.network(
        user.getProfilePictureUrl(),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.amber,
      );
    }
  }
}
