import 'package:connecta/screens/auth/login_screen.dart';
import 'package:connecta/screens/auth/signup_screen.dart';
import 'package:connecta/screens/main_screen.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade800,
              Colors.pink.shade700,
              Colors.pink.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // App Logo/Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade900.withOpacity(0.25),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.heart,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // App Name
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.white, Colors.pink.shade200],
                  ).createShader(bounds),
                  child: Text(
                    AppText.appName,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  AppText.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 3),
                // Action Buttons
                Column(
                  children: [
                    CustomButton(
                      text: AppText.signup,
                      width: double.infinity,
                      backgroundColor: Colors.pink.shade500,
                     textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppText.login,
                      width: double.infinity,
                      isOutlined: true,
                      backgroundColor: Colors.white,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}