//editprofilepicture.dart;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sportplays/models/user.dart';

class EditProfilePicture extends StatefulWidget {
  final User passUser;

  const EditProfilePicture({Key? key, required this.passUser}) : super(key: key);

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  File? _pickedImage;

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

  Future<String?> _uploadProfilePicture() async {
    try {
      String fileName = widget.passUser.getId(); // Use the user's ID as the filename
      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/$fileName');

      await reference.putFile(_pickedImage!);

      // Get the download URL
      String imageUrl = await reference.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.amber,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _pickImageFromGallery();
              },
              child: const Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _pickImageFromCamera();
              },
              child: const Text('Pick Image from Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_pickedImage != null) {
                  String? imageUrl = await _uploadProfilePicture();
                  if (imageUrl != null) {
                    Navigator.pop(context, imageUrl);
                  } else {
                    // Handle the error
                  }
                }
              },
              child: const Text('Save Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
