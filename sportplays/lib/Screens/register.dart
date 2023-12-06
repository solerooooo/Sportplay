// register.dart
import 'package:flutter/material.dart';
import 'login.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Register to SportPlay',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.card_membership),
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.home),
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.people),
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                height: 70,
                child: ElevatedButton(
                  onPressed: () async {
                    // Create a map with user data
                    Map<String, dynamic> userData = {
                      'name': nameController.text,
                      'email': emailController.text,
                      'password': passwordController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'gender': genderController.text,
                      'userId': idController.text,
                    };
                    try {
                      // Add user data to Firestore
                      await FirebaseFirestore.instance
                          .collection(
                              'UserData') // Your collection name in Firestore
                          .doc(nameController
                              .text) // Document name based on the 'name'
                          .set(userData);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    } catch (error) {
                      // Handle any errors that might occur during data insertion
                      print('Error adding user data to Firestore: $error');
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
