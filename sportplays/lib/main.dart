// main.dart
import 'package:flutter/material.dart';
import 'package:sportplays/Screens/splash_screen.dart';
import 'package:sportplays/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
    

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportplays',
      home: SplashScreen(),
    );
  }
}
