import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import '../main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<Map<String, dynamic>> _getAuthPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'remember_me': prefs.getBool('remember_me') ?? false,
      'has_seen_welcome': prefs.getBool('has_seen_welcome') ?? false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAuthPreferences(),
      builder: (context, prefSnapshot) {
        // Show loading while getting preferences
        if (prefSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If we have preferences data
        if (prefSnapshot.hasData) {
          final preferences = prefSnapshot.data!;
          final bool rememberMe = preferences['remember_me'];
          final bool hasSeenWelcome = preferences['has_seen_welcome'];

          debugPrint('Remember me: $rememberMe');
          debugPrint('Has seen welcome: $hasSeenWelcome');

          // If user hasn't seen welcome screen yet, show it
          if (!hasSeenWelcome) {
            return const WelcomeScreen();
          }

          // Check auth state regardless of rememberMe setting
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              // Show loading while checking auth state
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // User is logged in - go to main screen
              if (authSnapshot.hasData) {
                return const MainScreen();
              }

              // User not logged in - check rememberMe to decide which screen to show
              return rememberMe ? const LoginScreen() : const WelcomeScreen();
            },
          );
        }

        // Fallback if we don't have preferences data
        return const WelcomeScreen();
      },
    );
  }
}