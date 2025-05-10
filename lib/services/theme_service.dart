import 'package:flutter/material.dart';
import 'package:connecta/models/theme_model.dart';

class ThemeService with ChangeNotifier {
  late AppTheme _currentTheme;

  ThemeService() {
    _currentTheme = _availableThemes[0];
  }

  List<AppTheme> get availableThemes => _availableThemes;

  ThemeData get currentThemeData => ThemeData(
        primaryColor: _currentTheme.primaryColor,
        colorScheme: ColorScheme.light(
          primary: _currentTheme.primaryColor,
          secondary: _currentTheme.secondaryColor,
          background: _currentTheme.backgroundColor,
        ),
        scaffoldBackgroundColor: _currentTheme.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: _currentTheme.textColor),
          bodyMedium: TextStyle(color: _currentTheme.textColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: _currentTheme.primaryColor,
          titleTextStyle: TextStyle(
            color: _currentTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: _currentTheme.textColor),
        ),
      );

  AppTheme get currentTheme => _currentTheme;

  void changeTheme(AppTheme newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }

  static final List<AppTheme> _availableThemes = [
    // Default theme (free)
    AppTheme(
      id: 'default',
      name: 'Classic Connecta',
      description: 'Default theme with purple accent',
      primaryColor: Colors.purple.shade800,
      secondaryColor: Colors.purple.shade300,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      cost: 0,
      changesAppIcon: false,
      isPremium: false,
    ),

    // Ocean theme (changes app icon)
    AppTheme(
      id: 'ocean',
      name: 'Ocean Blue',
      description: 'Calming blue tones like the deep sea',
      primaryColor: const Color(0xFF1565C0),
      secondaryColor: const Color(0xFF4FC3F7),
      backgroundColor: const Color(0xFFE1F5FE),
      textColor: Colors.black87,
      cost: 50,
      changesAppIcon: true,
      iconPath: 'assets/icons/ocean_icon.png',
    ),

    // Dark theme (premium)
    AppTheme(
      id: 'midnight',
      name: 'Midnight',
      description: 'Dark theme for night owls',
      primaryColor: const Color(0xFF0D47A1),
      secondaryColor: const Color(0xFF1A237E),
      backgroundColor: const Color(0xFF121212),
      textColor: Colors.white70,
      cost: 100,
      changesAppIcon: true,
      iconPath: 'assets/icons/midnight_icon.png',
      isPremium: true,
    ),

    // Warm theme
    AppTheme(
      id: 'sunset',
      name: 'Sunset',
      description: 'Warm colors of a summer sunset',
      primaryColor: const Color(0xFFFF7043),
      secondaryColor: const Color(0xFFFFA000),
      backgroundColor: const Color(0xFFFFF3E0),
      textColor: Colors.black87,
      cost: 75,
    ),

    // Nature theme
    AppTheme(
      id: 'forest',
      name: 'Forest',
      description: 'Fresh green tones like a forest',
      primaryColor: const Color(0xFF2E7D32),
      secondaryColor: const Color(0xFF66BB6A),
      backgroundColor: const Color(0xFFE8F5E9),
      textColor: Colors.black87,
      cost: 60,
    ),

    // Vibrant theme (changes app icon, premium)
    AppTheme(
      id: 'neon',
      name: 'Neon Dreams',
      description: 'Vibrant neon colors for party people',
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFFE91E63),
      backgroundColor: Colors.black,
      textColor: Colors.white,
      cost: 150,
      changesAppIcon: true,
      iconPath: 'assets/icons/neon_icon.png',
      isPremium: true,
    ),

    // Professional theme
    AppTheme(
      id: 'professional',
      name: 'Executive',
      description: 'Clean and professional look',
      primaryColor: const Color(0xFF263238),
      secondaryColor: const Color(0xFF607D8B),
      backgroundColor: const Color(0xFFECEFF1),
      textColor: Colors.black87,
      cost: 80,
    ),

    // Romantic theme (changes app icon)
    AppTheme(
      id: 'romantic',
      name: 'Romantic',
      description: 'Soft pink tones for romance',
      primaryColor: const Color(0xFFC2185B),
      secondaryColor: const Color(0xFFF8BBD0),
      backgroundColor: const Color(0xFFFCE4EC),
      textColor: Colors.black87,
      cost: 120,
      changesAppIcon: true,
      iconPath: 'assets/icons/romantic_icon.png',
    ),
  ];
}