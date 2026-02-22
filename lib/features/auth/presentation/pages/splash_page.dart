import 'package:flutter/material.dart';

/// Splash screen — checks auth status and navigates accordingly.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate checking auth token and navigating
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // For now, always go to Get Started page in this demo
        Navigator.pushReplacementNamed(context, '/get-started');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Match GetStarted theme
      body: Center(
        child: Text(
          '🐸 Kippy',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8DEE10), // Lime Green
          ),
        ),
      ),
    );
  }
}
