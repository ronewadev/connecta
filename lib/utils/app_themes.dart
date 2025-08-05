import 'package:flutter/material.dart';

enum AppThemeType { pink, blue, purple, green, orange }

class AppThemes {
  // Pink Theme (Default) - Darker Pink for Light, Darker Purple for Dark
  static const Color _darkPink = Color(0xFFE91E63); // Darker, more vibrant pink
  
  static final pinkLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: _darkPink),
      titleTextStyle: const TextStyle(color: _darkPink, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: _darkPink),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: _darkPink, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
      primary: _darkPink,
      secondary: Colors.pinkAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static const Color _darkPurple = Color(0xFF7B1FA2); // Darker purple for dark mode
  
  static final pinkDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: const Color(0xFF181818),
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF181818).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: _darkPurple),
      titleTextStyle: const TextStyle(color: _darkPurple, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: _darkPurple),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: _darkPurple, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple, brightness: Brightness.dark).copyWith(
      primary: _darkPurple,
      secondary: Colors.purple,
      surface: const Color(0xFF181818).withOpacity(0.8),
    ),
  );

  // Blue Theme - Blue for Light, Indigo for Dark
  static final blueLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.blue),
      titleTextStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.blue),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final blueDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A2E).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.indigoAccent),
      titleTextStyle: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.indigoAccent),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark).copyWith(
      primary: Colors.indigoAccent,
      secondary: Colors.indigo,
      surface: const Color(0xFF1A1A2E).withOpacity(0.8),
    ),
  );

  // Purple Theme - Purple for Light, Deep Purple for Dark
  static final purpleLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.purple),
      titleTextStyle: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.purple),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
      primary: Colors.purple,
      secondary: Colors.purpleAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final purpleDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF2A1B3D),
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2A1B3D).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
      titleTextStyle: const TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple, brightness: Brightness.dark).copyWith(
      primary: Colors.deepPurpleAccent,
      secondary: Colors.deepPurple,
      surface: const Color(0xFF2A1B3D).withOpacity(0.8),
    ),
  );

  // Green Theme - Green for Light, Teal for Dark
  static final greenLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.green),
      titleTextStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.green),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
      primary: Colors.green,
      secondary: Colors.greenAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final greenDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF1B3A1B),
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1B3A1B).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.tealAccent),
      titleTextStyle: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.tealAccent),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal, brightness: Brightness.dark).copyWith(
      primary: Colors.tealAccent,
      secondary: Colors.teal,
      surface: const Color(0xFF1B3A1B).withOpacity(0.8),
    ),
  );

  // Orange Theme - Orange for Light, Deep Orange for Dark
  static final orangeLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.orange),
      titleTextStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.orange),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange).copyWith(
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final orangeDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: const Color(0xFF3A2A1B),
    fontFamily: 'Baloo',
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF3A2A1B).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
      titleTextStyle: const TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange, brightness: Brightness.dark).copyWith(
      primary: Colors.deepOrangeAccent,
      secondary: Colors.deepOrange,
      surface: const Color(0xFF3A2A1B).withOpacity(0.8),
    ),
  );

  // Theme selector methods
  static ThemeData getLightTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.pink:
        return pinkLightTheme;
      case AppThemeType.blue:
        return blueLightTheme;
      case AppThemeType.purple:
        return purpleLightTheme;
      case AppThemeType.green:
        return greenLightTheme;
      case AppThemeType.orange:
        return orangeLightTheme;
    }
  }

  static ThemeData getDarkTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.pink:
        return pinkDarkTheme;
      case AppThemeType.blue:
        return blueDarkTheme;
      case AppThemeType.purple:
        return purpleDarkTheme;
      case AppThemeType.green:
        return greenDarkTheme;
      case AppThemeType.orange:
        return orangeDarkTheme;
    }
  }

  static String getThemeName(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.pink:
        return 'Pink Rose';
      case AppThemeType.blue:
        return 'Ocean Blue';
      case AppThemeType.purple:
        return 'Royal Purple';
      case AppThemeType.green:
        return 'Nature Green';
      case AppThemeType.orange:
        return 'Sunset Orange';
    }
  }

  static Color getThemeColor(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.pink:
        return _darkPink;
      case AppThemeType.blue:
        return Colors.blue;
      case AppThemeType.purple:
        return Colors.purple;
      case AppThemeType.green:
        return Colors.green;
      case AppThemeType.orange:
        return Colors.orange;
    }
  }

  // Get the current theme color based on brightness
  static Color getCurrentThemeColor(AppThemeType themeType, bool isDarkMode) {
    switch (themeType) {
      case AppThemeType.pink:
        return isDarkMode ? _darkPurple : _darkPink;
      case AppThemeType.blue:
        return isDarkMode ? Colors.indigoAccent : Colors.blue;
      case AppThemeType.purple:
        return isDarkMode ? Colors.deepPurpleAccent : Colors.purple;
      case AppThemeType.green:
        return isDarkMode ? Colors.tealAccent : Colors.green;
      case AppThemeType.orange:
        return isDarkMode ? Colors.deepOrangeAccent : Colors.orange;
    }
  }

  // For backward compatibility
  static ThemeData get lightTheme => pinkLightTheme;
  static ThemeData get darkTheme => pinkDarkTheme;
}
