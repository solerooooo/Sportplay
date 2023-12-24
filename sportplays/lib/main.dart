//main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sportplays/Screens/splash_screen.dart';
import 'package:sportplays/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51OQ77jL9jiXabeNWXfQKOWdJlsHW4XUId3OY50uQNjTg4q78m1NJgGmAXFjr8jJmCgFdBKmDIQ6rmrxKHSgXHGrv00n3z6O5am';
  await dotenv.load(fileName: "assets/.env");  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sportplays Booking System',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(),
    );
  }
}
