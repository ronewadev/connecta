import 'package:flutter/material.dart';
import 'package:connecta/utils/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  AppThemeType _selectedTheme = AppThemeType.pink;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;
  AppThemeType get selectedTheme => _selectedTheme;
  bool get isLoading => _isLoading;

  // Initialize theme from saved preferences
  Future<void> loadThemePreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load theme mode
      final themeModeIndex = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      // Load selected theme - default to pink for logged out users
      final themeTypeIndex = prefs.getInt('theme_type') ?? AppThemeType.pink.index;
      _selectedTheme = AppThemeType.values[themeTypeIndex];
      
      // Ensure pink is default for new installations
      if (!prefs.containsKey('theme_type')) {
        _selectedTheme = AppThemeType.pink;
        await prefs.setInt('theme_type', AppThemeType.pink.index);
      }
      
    } catch (e) {
      debugPrint('Error loading theme preferences: $e');
      // If there's an error, default to pink theme
      _selectedTheme = AppThemeType.pink;
      _themeMode = ThemeMode.system;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save theme preferences
  Future<void> _saveThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', _themeMode.index);
      await prefs.setInt('theme_type', _selectedTheme.index);
    } catch (e) {
      debugPrint('Error saving theme preferences: $e');
    }
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setTheme(ThemeMode.light);
    } else {
      await setTheme(ThemeMode.dark);
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      await _saveThemePreferences();
    }
  }

  Future<void> setSelectedTheme(AppThemeType themeType) async {
    if (_selectedTheme != themeType) {
      _selectedTheme = themeType;
      notifyListeners();
      await _saveThemePreferences();
    }
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  ThemeData get lightTheme => AppThemes.getLightTheme(_selectedTheme);
  ThemeData get darkTheme => AppThemes.getDarkTheme(_selectedTheme);

  // Get current active theme
  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;
  
  // Get theme name for display
  String get currentThemeName => AppThemes.getThemeName(_selectedTheme);
  
  // Get theme color for display - uses appropriate color for current mode
  Color get currentThemeColor => AppThemes.getCurrentThemeColor(_selectedTheme, isDarkMode);
  
  // Reset theme to pink (for logout)
  Future<void> resetThemeToPink() async {
    _selectedTheme = AppThemeType.pink;
    _themeMode = ThemeMode.system;
    notifyListeners();
    await _saveThemePreferences();
  }
}