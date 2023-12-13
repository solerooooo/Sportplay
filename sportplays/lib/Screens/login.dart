//login.dart 
import 'package:flutter/material.dart';
import 'package:sportplays/Screens/home.dart';
import 'package:sportplays/Screens/home_admin.dart';
import 'package:sportplays/Screens/register.dart';
import 'package:sportplays/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("images/background.jpg"), //set image file name here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'SOLEROOOOO',
                    style:
                        headerTextStyle.copyWith(fontStyle: FontStyle.italic),
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
                    controller: passwordController,
                    obscureText: true,
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
                        // Retrieve user data from Firestore
                     try {
  DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance
          .collection('UserData')
          .doc(nameController.text)
          .get();

  if (userSnapshot.exists) {
    // Check if the user is an admin
    if (userSnapshot['userId'] == 'ADMIN' &&
        userSnapshot['password'] == passwordController.text) {
      // Admin found, navigate to HomeAdmin
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeAdmin(
            passUser: User(
              name: userSnapshot['name'],
              email: userSnapshot['email'],
              password: userSnapshot['password'],
              phone: userSnapshot['phone'],
              address: userSnapshot['address'],
              gender: userSnapshot['gender'],
              userId: userSnapshot['userId'],
            ),
          ),
        ),
      );
    } else if (userSnapshot['password'] == passwordController.text) {
      // Regular user found, navigate to Home
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
      // Password incorrect
      print('Incorrect password');
    }
  } else {
    // User not found
    print('User not found');
  }
} catch (error) {
  // Handle errors
  print('Error fetching user data from Firestore: $error');
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
                            style:
                                buttonTextStlye.copyWith(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFC9DB7E),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Forgot password? ",
                      style: labelTextStyle.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Reset password",
                          style: labelTextStyle.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 40,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: labelTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF444444),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register here',
                            style:
                                buttonTextStlye.copyWith(color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFC9DB7E),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
