import 'package:cropnurture/onboarding_screen/onboarding_screen.dart';
import 'package:cropnurture/screens/Home_screen.dart';
import 'package:cropnurture/screens/home.dart';
import 'package:cropnurture/screens/navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home:  FarmerHome(),
      debugShowCheckedModeBanner: false,

    );

  }
}

class AnimatedLogoScreen extends StatefulWidget {
  @override
  _AnimatedLogoScreenState createState() => _AnimatedLogoScreenState();
}

class _AnimatedLogoScreenState extends State<AnimatedLogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Duration of the animation
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Listen for animation completion
    _controller.forward().whenComplete(() {
      // Navigate to another page after animation
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
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
      backgroundColor: Colors.green[50], // Light green background
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Image.asset(
            'assets/images/logo.png', // Path to your logo
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}

