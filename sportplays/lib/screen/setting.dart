// setting.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
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
  final TextEditingController lastPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  bool _isLastPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmNewPasswordVisible = false;
  String selectedGender = '';
  late String originalGender;
  File? _pickedImage;
  String get imageUrl =>
      _pickedImage != null ? _pickedImage!.path : user.getProfilePictureUrl();

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

 Widget buildPasswordFields(StateSetter setState) {
  return Column(
    children: [
      buildPasswordField(
        Icons.lock,
        'Last Password',
        lastPasswordController,
        _isLastPasswordVisible,
        () {
          setState(() {
            _isLastPasswordVisible = !_isLastPasswordVisible;
          });
        },
      ),
      SizedBox(height: 10),
      buildPasswordField(
        Icons.lock,
        'New Password',
        newPasswordController,
        _isNewPasswordVisible,
        () {
          setState(() {
            _isNewPasswordVisible = !_isNewPasswordVisible;
          });
        },
      ),
      SizedBox(height: 10),
      buildPasswordField(
        Icons.lock,
        'Confirm New Password',
        confirmNewPasswordController,
        _isConfirmNewPasswordVisible,
        () {
          setState(() {
            _isConfirmNewPasswordVisible = !_isConfirmNewPasswordVisible;
          });
        },
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          if (_validatePasswordFields()) {
            _changePassword(lastPasswordController.text);
            Navigator.pop(context);
          }
        },
        child: Text('Submit'),
      ),
    ],
  );
}

Widget buildPasswordField(
  IconData icon,
  String label,
  TextEditingController controller,
  bool isPasswordVisible,
  VoidCallback onPressed,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(width: 10),
      Expanded(
        child: SizedBox(
          width: 250,
          child: TextField(
            controller: controller,
            obscureText: !isPasswordVisible,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              prefixIcon: Icon(icon),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: onPressed,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildChangePasswordButton() {
  return ElevatedButton(
    onPressed: () {
      _handlePasswordChangeButtonPress();
    },
    child: Text('Change Password'),
  );
}

void _handlePasswordChangeButtonPress() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Change Password'),
      content: Container(
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return buildPasswordFields(setState);
            },
          ),
        ),
      ),
    ),
  );
}


  bool _validatePasswordFields() {
    if (lastPasswordController.text != user.getPassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect last password'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (newPasswordController.text.isEmpty ||
        newPasswordController.text.length < 6 ||
        !_isPasswordComplex(newPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'New password must be at least 6 characters and meet the complexity requirements',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    if (newPasswordController.text != confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }

    return true;
  }

  void _changePassword(String lastPassword) {
    if (lastPassword != user.getPassword()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect last password'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    user = user.copyWith(password: newPasswordController.text);
    updateUserDataInFirestore(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password changed successfully'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool _isPasswordComplex(String password) {
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(password);
    bool hasNumber = RegExp(r'\d').hasMatch(password);
    bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    if (password.length < 6 || !hasSpecialChar || !hasNumber || !hasUppercase) {
      return false;
    }

    return true;
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

      String imageUrl = await reference.getDownloadURL();

      setState(() {
        user = user.copyWith(profilePictureUrl: imageUrl);
      });

      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null;
    }
  }

  void saveChanges() async {
    String? imageUrl;

    if (_pickedImage != null) {
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
      profilePictureUrl: imageUrl ?? '',
    );

    await updateUserDataInFirestore(updatedUser);
    widget.onUpdateUser(updatedUser);
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
                  buildProfilePicture(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImageFromGallery();
                    },
                    child: const Text('Pick Image from Gallery'),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 21.5,
                    ),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                        buildTextField(
                            Icons.phone, 'Phone Number', phoneController),
                        const SizedBox(height: 10),
                        buildTextField(
                            Icons.home, 'Address', addressController),
                        const SizedBox(height: 10),
                        buildGenderDropdown(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildChangePasswordButton(),
                  const SizedBox(height: 10),
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

  Widget buildTextField(
      IconData icon, String label, TextEditingController controller) {
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
