import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogoutDialog {
  static Future<void> show({
    required BuildContext context,
    required VoidCallback onNavigateToWelcomeScreen,
    String? title,
    String? message,
    String? cancelText,
    String? confirmText,
    Color? confirmButtonColor,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => _LogoutConfirmationDialog(
        title: title,
        message: message,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmButtonColor: confirmButtonColor,
        onNavigateToWelcomeScreen: onNavigateToWelcomeScreen,
      ),
    );
  }
}

class _LogoutConfirmationDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? cancelText;
  final String? confirmText;
  final Color? confirmButtonColor;
  final VoidCallback onNavigateToWelcomeScreen;

  const _LogoutConfirmationDialog({
    this.title,
    this.message,
    this.cancelText,
    this.confirmText,
    this.confirmButtonColor,
    required this.onNavigateToWelcomeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title ?? 'Logout',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(message ??
          'Are you sure you want to logout? You will need to sign in again to access your account.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            // Set rememberMe to false in Firestore before logging out
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .update({'rememberMe': false});
            }
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context); // Close the dialog
            onNavigateToWelcomeScreen();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            confirmText ?? 'Logout',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}