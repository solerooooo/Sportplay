//splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sportplays/Screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed( Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
        builder: (_) =>  Login(),
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreenAccent, Colors.purple],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo.png',
                  height: 300,
                ),
                 SizedBox(height: 20),
                 Text(
                  'SOLEROOOOO',
                  style: GoogleFonts.macondoSwashCaps(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                )
              ],
            )));
  }
}
