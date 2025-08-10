import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences {
  static const String _rememberMeKey = 'remember_me';
  static const String _hasSeenWelcomeKey = 'has_seen_welcome';

  /// Get the remember me preference
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Set the remember me preference
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  /// Get whether user has seen the welcome screen
  static Future<bool> getHasSeenWelcome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenWelcomeKey) ?? false;
  }

  /// Set that user has seen the welcome screen
  static Future<void> setHasSeenWelcome(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenWelcomeKey, value);
  }

  /// Clear all auth preferences (used on logout)
  static Future<void> clearAuthPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, false);
    // Don't clear has_seen_welcome as user has already seen it
  }

  /// Get all auth preferences at once
  static Future<Map<String, bool>> getAllAuthPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'remember_me': prefs.getBool(_rememberMeKey) ?? false,
      'has_seen_welcome': prefs.getBool(_hasSeenWelcomeKey) ?? false,
    };
  }
}
