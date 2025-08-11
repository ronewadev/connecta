import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../providers/theme_provider.dart';
import '../database/user_database.dart';

class AuthService with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserDatabase _userDatabase = UserDatabase();
  
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  firebase_auth.User? get firebaseUser => _firebaseAuth.currentUser;

  // Stream to listen to auth state changes
  Stream<firebase_auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  AuthService() {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        // User is signed in, fetch user data from Firestore
        await _loadUserFromFirestore(firebaseUser.uid);
      } else {
        // User is signed out
        _currentUser = null;
        _isAuthenticated = false;
        notifyListeners();
      }
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = User.fromMap(doc.data() as Map<String, dynamic>, uid);
        _isAuthenticated = true;
        
        // Also initialize UserDatabase for the profile screen
        await _userDatabase.initializeUserData();
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // Check if username is already taken
      QuerySnapshot usernameQuery = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      if (usernameQuery.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'Username is already taken',
        };
      }

      // Create user with Firebase Auth
      firebase_auth.UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Create user document in Firestore with basic info
        User newUser = User(
          id: userCredential.user!.uid,
          username: username,
          email: email,
          age: 18, // Default age, will be updated in onboarding
          gender: 'Not specified',
          nationality: 'Not specified',
          location: 'Not specified',
          profileImageUrl: '',
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());
        
        _currentUser = newUser;
        _isAuthenticated = true;
        notifyListeners();

        return {
          'success': true,
          'message': 'Account created successfully',
          'user': newUser,
        };
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'An error occurred during sign up';
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = e.message ?? message;
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }

    return {
      'success': false,
      'message': 'Sign up failed',
    };
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Update last active and online status
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'lastActive': FieldValue.serverTimestamp(),
          'isOnline': true,
        });

        await _loadUserFromFirestore(userCredential.user!.uid);

        return {
          'success': true,
          'message': 'Signed in successfully',
          'user': _currentUser,
        };
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'An error occurred during sign in';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message = 'Too many sign in attempts. Please try again later.';
          break;
        default:
          message = e.message ?? message;
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: ${e.toString()}',
      };
    }

    return {
      'success': false,
      'message': 'Sign in failed',
    };
  }

  // Send email verification
  Future<Map<String, dynamic>> sendEmailVerification() async {
    try {
      firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return {
          'success': true,
          'message': 'Verification email sent',
        };
      }
      return {
        'success': false,
        'message': 'No user found or email already verified',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send verification email: ${e.toString()}',
      };
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  // Reload current user to check verification status
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
    notifyListeners();
  }

  // Update user profile in Firestore
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      if (_currentUser != null) {
        await _firestore.collection('users').doc(_currentUser!.id).update(data);
        await _loadUserFromFirestore(_currentUser!.id);
        return {
          'success': true,
          'message': 'Profile updated successfully',
        };
      }
      return {
        'success': false,
        'message': 'No user logged in',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to update profile: ${e.toString()}',
      };
    }
  }

  // Sign out
  Future<void> signOut([BuildContext? context]) async {
    try {
      // Update online status before signing out
      if (_currentUser != null) {
        await _firestore.collection('users').doc(_currentUser!.id).update({
          'isOnline': false,
          'lastActive': FieldValue.serverTimestamp(),
        });
      }

      await _firebaseAuth.signOut();
      
      _currentUser = null;
      _isAuthenticated = false;
      
      // Reset theme to pink on logout
      if (context != null) {
        try {
          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
          await themeProvider.resetThemeToPink();
        } catch (e) {
          debugPrint('Error resetting theme on logout: $e');
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // Send password reset email
  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent',
      };
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = e.message ?? message;
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send password reset email: ${e.toString()}',
      };
    }
  }

  // Legacy methods for backward compatibility
  Future<void> login(String username, String password) async {
    // This method is kept for backward compatibility
    // In practice, we should use signIn method
    await signIn(email: username, password: password);
  }

  Future<void> logout([BuildContext? context]) async {
    await signOut(context);
  }

  Future<void> register(User newUser, String password) async {
    // This method is kept for backward compatibility
    // In practice, we should use signUp method
    await signUp(
      email: newUser.email,
      password: password,
      username: newUser.username,
    );
  }
}