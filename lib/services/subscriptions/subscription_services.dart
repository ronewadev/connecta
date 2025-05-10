import 'package:flutter/material.dart';

class SubscriptionService with ChangeNotifier {
  String _subscriptionType = 'basic'; // 'basic', 'premium', 'infinity'
  DateTime? _premiumExpiry;

  String get subscriptionType => _subscriptionType;
  DateTime? get premiumExpiry => _premiumExpiry;

  void subscribe(String type, Duration duration) {
    _subscriptionType = type;
    _premiumExpiry = DateTime.now().add(duration);
    notifyListeners();
  }

  void checkSubscriptionStatus() {
    if (_premiumExpiry != null && DateTime.now().isAfter(_premiumExpiry!)) {
      _subscriptionType = 'basic';
      _premiumExpiry = null;
      notifyListeners();
    }
  }

  bool get isPremium => _subscriptionType == 'premium' || _subscriptionType == 'infinity';
  bool get isInfinity => _subscriptionType == 'infinity';
}