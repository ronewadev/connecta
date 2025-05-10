import 'package:flutter/material.dart';

class TokenService with ChangeNotifier {
  int _silverTokens = 0;
  int _goldTokens = 0;

  int get silverTokens => _silverTokens;
  int get goldTokens => _goldTokens;

  void earnSilverTokens(int amount) {
    _silverTokens += amount;
    notifyListeners();
  }

  void spendSilverTokens(int amount) {
    if (_silverTokens >= amount) {
      _silverTokens -= amount;
      notifyListeners();
    }
  }

  void buyGoldTokens(int amount) {
    _goldTokens += amount;
    notifyListeners();
  }

  void spendGoldTokens(int amount) {
    if (_goldTokens >= amount) {
      _goldTokens -= amount;
      notifyListeners();
    }
  }
}