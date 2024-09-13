import 'package:flutter/material.dart';
import 'dart:async'; // For the Timer class
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat animation

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Check user authentication status and navigate accordingly
    Timer(Duration(seconds: 10), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, navigate to HomePage
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // User is not logged in, navigate to SignInPage
        Navigator.of(context).pushReplacementNamed('/signin');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image
            Image.asset(
              'assets/images/wait-gif.gif', // Replace with your image asset
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),

            // Animated text
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Recipe Generator powered by Abdul Hannan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
