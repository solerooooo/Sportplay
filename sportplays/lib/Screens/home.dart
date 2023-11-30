// home.dart
import 'package:flutter/material.dart';
import 'login.dart';
import 'profile.dart';
import 'register.dart';
import '../models/user.dart';

class Home extends StatelessWidget {
  final User passUser;

  const Home({Key? key, required this.passUser}) : super(key: key);

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(passUser: passUser)),
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
              'Welcome, ${passUser.getName()}!',
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
