import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/theme_provider.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    // Implement actual login logic
    _currentUser = User(
      id: '1',
      username: username,
      email: '$username@connecta.com',
      age: 25,
      gender: 'Other',
      nationality: 'RSA',
      name: 'Jeffrey Mabaso',
      location: 'Thohoyandou',
    );
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout([BuildContext? context]) async {
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
  }

  Future<void> register(User newUser, String text) async {
    // Implement registration logic
    _currentUser = newUser;
    _isAuthenticated = true;
    notifyListeners();
  }
}