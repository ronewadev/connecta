import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_screen.dart';

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
        if (!prefSnapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final preferences = prefSnapshot.data!;
        final bool rememberMe = preferences['remember_me'];
        final bool hasSeenWelcome = preferences['has_seen_welcome'];

        // If user hasn't seen welcome screen yet, show it
        if (!hasSeenWelcome) {
          return const WelcomeScreen();
        }

        if (rememberMe) {
          // If remember me is enabled, use StreamBuilder to listen to auth state
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // Show loading while checking auth state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // If user is logged in and remember me is enabled
              if (snapshot.hasData) {
                return const MainScreen();
              }

              // If not logged in, show login screen
              return const LoginScreen();
            },
          );
        } else {
          // If remember me is not enabled, always show login screen
          return const LoginScreen();
        }
      },
    );
  }
}
