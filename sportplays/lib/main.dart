// main.dart
import 'package:flutter/material.dart';
import 'package:sportplays/firebase_options.dart';
import 'Screens/Register.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportplays Booking System',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Register(),
    );
  }
}
