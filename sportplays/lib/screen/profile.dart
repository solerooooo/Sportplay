import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'setting.dart';

class Profile extends StatefulWidget {
  final User passUser;

  const Profile({Key? key, required this.passUser}) : super(key: key);

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

  Widget buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: const Text(
          'User Profile',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Navigate to the Setting page and wait for the result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Setting(
                    passUser: passUser,
                    onUpdateUser: (User updatedUser) {
                      setState(() {
                        passUser = updatedUser;
                      });
                    },
                    firestore: FirebaseFirestore.instance,
                  ),
                ),
              );

              // Handle the result if needed
              if (result != null) {
                // Do something with the result if needed
              }
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  buildProfilePicture(),
                  const SizedBox(height: 10),
                  Text(
                    '${passUser.getName()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21.5,
                    ),
                  ),
                  Text(
                    '${passUser.getId()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Center(
                      child: Text(
                        'Active Student',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'About',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildInfoRow(Icons.person, passUser.getEmail()),
                        const SizedBox(height: 20),
                        buildInfoRow(Icons.phone, passUser.getPhone()),
                        const SizedBox(height: 20),
                        buildInfoRow(Icons.home, passUser.getAddress()),
                        const SizedBox(height: 20),
                        buildInfoRow(Icons.work, passUser.getGender()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Booking Notification',
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(width: 10),
                        NotiSwitch(),
                      ],
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

  Widget buildProfilePicture() {
    if (passUser.getProfilePictureUrl().isNotEmpty) {
      return Image.network(
        passUser.getProfilePictureUrl(),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.amber,
      );
    }
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
