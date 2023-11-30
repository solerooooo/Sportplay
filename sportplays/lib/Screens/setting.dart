/*// setting.dart
import 'package:flutter/material.dart';
import '../Models/user.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  List<User> computerStudents = [
    User(name: 'Camily', email: 'camily@utm.edu.my'),
    User(name: 'Solihin', email: 'solihin@utm.edu.my'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        actions: [
          IconButton(
            onPressed: () {
              //declare
              final nameController = TextEditingController();
              final emailController = TextEditingController();

              //create a popup form
              AlertDialog alertDialog = AlertDialog(
                title: const Text('Add Student'),
                content: SizedBox(
                  width: 200,
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                      ),
                      TextField(
                        controller: emailController,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      //code add student
                      computerStudents.add(
                        User(
                          name: nameController.text,
                          email: emailController.text,
                        ),
                      );
                      setState(() {
                        //refresh screen
                      });
                      //close popup
                      Navigator.pop(context);
                    },
                    child: Text('Ok'),
                  ),
                ],
              );
              showDialog(
                context: context,
                builder: (context) {
                  return alertDialog;
                },
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: computerStudents.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(computerStudents[index].name),
            subtitle: Text(computerStudents[index].email),
            trailing: IconButton(
              onPressed: () {
                //delete
                computerStudents.removeAt(index);
                setState(() {
                  //refresh screen
                });
              },
              icon: Icon(Icons.clear),
            ),
          );
        },
      ),
    );
  }
}*/
