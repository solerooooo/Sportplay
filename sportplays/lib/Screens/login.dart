import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Define a custom color
  Color customPurpleColor = Color(0xFFB364F3);

  // Define text styles to reuse
  final TextStyle headerTextStyle = TextStyle(
    color: Colors.lightGreenAccent,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  final TextStyle labelTextStyle = TextStyle(
    fontSize: 15,
  );

  final TextStyle buttonTextStlye = TextStyle(
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the Top AppBar
      appBar: null,
      backgroundColor:
          customPurpleColor, // Set background color to custom purple
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  'SOLEROOOOO',
                  style: headerTextStyle,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'images/logo.png',
                  height: 300,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    label: Text('Email Address', style: labelTextStyle),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text('Password', style: labelTextStyle),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Retrieve user data from Firestore
                      try {
                        DocumentSnapshot userSnapshot = await FirebaseFirestore
                            .instance
                            .collection('UserData')
                            .doc(nameController.text)
                            .get();

                        if (userSnapshot.exists) {
                          // User found in Firestore, create User object
                          User passUser = User(
                            name: userSnapshot['name'],
                            email: userSnapshot['email'],
                            password: userSnapshot['password'],
                            phone: userSnapshot['phone'],
                            address: userSnapshot['address'],
                            gender: userSnapshot['gender'],
                            userId: userSnapshot['userId'],
                          );

                          // Navigate to Home screen with the User object
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(passUser: passUser),
                            ),
                          );
                        } else {
                          // User not found in Firestore, handle accordingly
                          // For now, you can display a message or take appropriate action
                          print('User not found');
                        }
                      } catch (error) {
                        print(
                            'Error fetching user data from Firestore: $error');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent,
                    ),
                    child: Text(
                      'Log in',
                      style: buttonTextStlye,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'New to SportPlay? Register',
                  style: labelTextStyle,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreenAccent,
                    ),
                    child: Text(
                      'Register',
                      style: buttonTextStlye,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
