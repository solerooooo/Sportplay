import 'package:flutter/material.dart';
import 'login.dart';
import 'profile.dart';
import 'register.dart';
import '../models/user.dart';
import 'booking.dart';

class Home extends StatefulWidget {
  final User passUser;

  const Home({Key? key, required this.passUser}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BookingPage(),
        ),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(passUser: widget.passUser),
        ),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(passUser: widget.passUser),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('HomePage'),
        backgroundColor: Colors.lightGreenAccent,
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
                  MaterialPageRoute(
                      builder: (context) => Profile(passUser: widget.passUser)),
                );
              },
            ),
            ListTile(
              title: const Text('Booking Page'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(passUser: widget.passUser)),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'Welcome, ${widget.passUser.getName()}!',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 400,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Today's News!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sports Hall Repair News Report',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'We would like to inform you that the sports hall is currently undergoing essential repairs and maintenance. This initiative is part of our ongoing efforts to enhance the overall facility and ensure a safe and enjoyable environment for everyone.',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 400,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Looking for a court to book?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookingPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreenAccent,
                        ), // Set the button color
                        child: const Text(
                          'Book here',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.black, 
        unselectedItemColor: Colors.black.withOpacity(0.5),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Q&A',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
