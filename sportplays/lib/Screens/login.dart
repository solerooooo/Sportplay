//login.dart
import 'package:flutter/material.dart';
import 'package:sportplays/Screens/home.dart';
import 'package:sportplays/Screens/register.dart';
import 'package:sportplays/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController(); // Added this line for email
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextStyle labelTextStyle = TextStyle(
    fontSize: 15,
  );

  final TextStyle buttonTextStlye = TextStyle(
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'SOLEROOOOO',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'images/logo.png',
                      height: 300,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        label: Text('Name', style: labelTextStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email), // Change to email icon
                        label: Text('Email', style: labelTextStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        label: Text('Password', style: labelTextStyle),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential =
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              // Navigate to Home screen
                              Navigator.pushNamed(context, 'home');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF444444),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log in',
                              style: buttonTextStlye.copyWith(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFFC9DB7E),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ... (remaining widgets)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
