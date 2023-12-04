// profile.dart
import 'package:flutter/material.dart';
import '../Models/user.dart';
import 'setting.dart';

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
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
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
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber,
              ),
              const SizedBox(height: 10),
              Text(
                '${passUser.name}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${passUser.email}',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Container(
                      width: 300,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.lightGreenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Active Student',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ])),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'About',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 10),
                            Text(
                              '${passUser.email}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 10),
                            // Add your phone information here
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home),
                            const SizedBox(width: 10),
                            // Add your address information here
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.work),
                            const SizedBox(width: 10),
                            // Add your job information here
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Booking Notification',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(width: 10),
                        NotiSwitch(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotiSwitch extends StatefulWidget {
  const NotiSwitch({Key? key}) : super(key: key);

  @override
  State<NotiSwitch> createState() => _NotiSwitchState();
}

class _NotiSwitchState extends State<NotiSwitch> {
  bool light0 = true;
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          value: light0,
          onChanged: (bool value) {
            setState(() {
              light0 = value;
            });
          },
        ),
      ],
    );
  }
}
