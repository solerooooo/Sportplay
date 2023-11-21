// profile.dart
import 'package:flutter/material.dart';
import 'package:sportplays/user.dart';
import 'package:sportplays/setting.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.passUser}) : super(key: key);
  final User passUser;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User passUser;

  @override
  void initState() {
    super.initState();
    passUser = widget.passUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const Setting(),
              );
              Navigator.push(context, route);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber, // Update the path
              ),
              const SizedBox(height: 10),
              Text(
                '${passUser.name}',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                '${passUser.email}',
                style: TextStyle(fontSize: 20),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      
                    ),
                    child: const Text(
                      'Active Student',
                      style: TextStyle(fontSize: 20),
                    )
                  
                  )
                ],
              )
            ],
            
          ),
        ),
      ),
    );
  }
}
