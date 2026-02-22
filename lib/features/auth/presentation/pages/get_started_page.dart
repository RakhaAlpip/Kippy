import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/app_router.dart';

/// Constants for Get Started Page
class GetStartedConstants {
  static const Color primaryColor = Color(0xFF8DEE10); // Lime Green
  static const Color backgroundColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color subtitleColor = Colors.grey;
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GetStartedConstants.backgroundColor,
      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Animation
                Lottie.asset(
                  'assets/lottie/frog.json',
                  width: 250,
                  height: 250,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(
                        const ['**'], // applies to all layers
                        value: GetStartedConstants.primaryColor,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 1),

                // Headline Text
                const Text(
                  'Ready to Leap into the Moment?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: GetStartedConstants.textColor,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // Sub-headline Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Capture, share, and hop through amazing memories with Kippy.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: GetStartedConstants.subtitleColor,
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(flex: 2),

                // Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Login Page
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GetStartedConstants.primaryColor,
                      foregroundColor: Colors.black, // Dark text for contrast
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Start Hopping',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
