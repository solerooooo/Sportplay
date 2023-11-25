// home.dart
import 'package:flutter/material.dart';
import 'login.dart';
import 'profile.dart';
import 'register.dart';
import '../user.dart';

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
            ),
            ListTile(
              title: const Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Create a dummy user for demonstration purposes
                User dummyUser = User(name: 'John Doe', email: 'john.doe@example.com');

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(passUser: dummyUser)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Welcome!',
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
