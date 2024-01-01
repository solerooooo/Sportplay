//forgot_password.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

 Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email'),
            );
          },
        );
    } on FirebaseAuthException catch (e) {
      print(e);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
        );
    } catch (e) {
    print('Error: $e');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('An unexpected error occurred. Please try again later.'),
        );
      },
    );
  }
}

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  final TextStyle labelTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF444444), // Set text color to 0xFF444444
  );

  final TextStyle dontWorryTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFFC9DB7E), // Set text color to C9DB7E
  );

  final Color iconColor = Color(0xFFC9DB7E); // Set icon color to C9DB7E

  final Color buttonColor = Color(0xFFC9DB7E); // Set button color to C9DB7E

  final TextStyle resetPasswordTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF444444),
          image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align to the start (left)
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: iconColor),
                        ),
                        SizedBox(width: 80),
                        // Removed home icon
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Forgot Password?',
                        style: headerTextStyle, textAlign: TextAlign.left),
                    SizedBox(height: 20),
                    Text(
                      "Don't worry, we've got you covered!",
                      textAlign: TextAlign.left,
                      style: dontWorryTextStyle,
                    ),
                    SizedBox(height: 70),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        label: Text('Email address', style: labelTextStyle),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                   SizedBox(height: 60),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Call passwordReset function when the form is valid
                            passwordReset();
                          }
                        },
                        child: Text('Reset Password', style: resetPasswordTextStyle),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
