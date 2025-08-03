import 'package:flutter/material.dart';

import '../models/user_model.dart';

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

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> register(User newUser, String text) async {
    // Implement registration logic
    _currentUser = newUser;
    _isAuthenticated = true;
    notifyListeners();
  }
}