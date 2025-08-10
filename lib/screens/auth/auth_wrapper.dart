import 'package:connecta/database/user_database.dart';
import 'package:connecta/screens/auth/welcome_screen.dart';
import 'package:connecta/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, now check the rememberMe flag
          return FutureBuilder<UserData?>(
            future: UserDatabase().fetchCurrentUserData(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (userSnapshot.hasData && userSnapshot.data != null && userSnapshot.data!.rememberMe) {
                return const MainScreen();
              } else {
                // If rememberMe is false or user data is not available, log them out
                FirebaseAuth.instance.signOut();
                return const WelcomeScreen();
              }
            },
          );
        } else {
          // User is not logged in
          return const WelcomeScreen();
        }
      },
    );
  }
}
