import 'package:connecta/database/user_database.dart';
import 'package:flutter/material.dart';

class TokenService with ChangeNotifier {
  final UserDatabase _userDatabase = UserDatabase();

  int _silverTokens = 0;
  int _goldTokens = 0;

  int get silverTokens => _silverTokens;
  int get goldTokens => _goldTokens;

  TokenService() {
    _userDatabase.userDataStream.listen((userData) {
      if (userData != null) {
        _silverTokens = userData.silverTokens;
        _goldTokens = userData.goldTokens;
        notifyListeners();
      }
    });
  }

  void earnSilverTokens(int amount) {
    _userDatabase.updateTokens(silverTokens: _silverTokens + amount);
  }

  void spendSilverTokens(int amount) {
    if (_silverTokens >= amount) {
      _userDatabase.updateTokens(silverTokens: _silverTokens - amount);
    }
  }

  void buyGoldTokens(int amount) {
    _userDatabase.updateTokens(goldTokens: _goldTokens + amount);
  }

  void spendGoldTokens(int amount) {
    if (_goldTokens >= amount) {
      _userDatabase.updateTokens(goldTokens: _goldTokens - amount);
    }
  }
}