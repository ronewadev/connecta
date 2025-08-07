import 'package:flutter/material.dart';

enum AppThemeType { 
  pink, blue, purple, green, orange, red, cyan, amber, indigo, 
  teal, lime, deepOrange, blueGrey, brown, crimson, magenta, 
  violet, turquoise, gold, silver, emerald, ruby, sapphire, coral, mint
}

class AppThemes {
  // Pink Theme (Default) - Vibrant Pink for Light, Rose Gold for Dark
  static const Color _darkPink = Color(0xFFE91E63); // Darker, more vibrant pink
  static const Color _darkModeRose = Color(0xFFFF6B9D); // Beautiful rose gold for dark mode
  
  static final pinkLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
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

  static final pinkDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: const Color(0xFF0D1117), // GitHub dark background
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF161B22), // Subtle card background
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF161B22).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: _darkModeRose),
      titleTextStyle: const TextStyle(color: _darkModeRose, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: _darkModeRose),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: _darkModeRose, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink, brightness: Brightness.dark).copyWith(
      primary: _darkModeRose,
      secondary: Colors.pink.shade300,
      surface: const Color(0xFF161B22).withOpacity(0.8),
    ),
  );

  // Blue Theme - Ocean Blue for Light, Electric Blue for Dark
  static final blueLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
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
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0A0E27), // Deep navy background
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A1F3A), // Navy card background
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1F3A).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF64B5F6)), // Light blue
      titleTextStyle: const TextStyle(color: Color(0xFF64B5F6), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF64B5F6)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF64B5F6), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF64B5F6),
      secondary: Colors.blue.shade300,
      surface: const Color(0xFF1A1F3A).withOpacity(0.8),
    ),
  );

  // Purple Theme - Royal Purple for Light, Lavender for Dark
  static final purpleLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
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
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: const Color(0xFF1A0D2E), // Deep purple background
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1B42), // Rich purple card
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1B42).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFBA68C8)), // Light purple
      titleTextStyle: const TextStyle(color: Color(0xFFBA68C8), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFBA68C8)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFBA68C8), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFBA68C8),
      secondary: Colors.purple.shade300,
      surface: const Color(0xFF2D1B42).withOpacity(0.8),
    ),
  );

  // Green Theme - Forest Green for Light, Mint Green for Dark
  static final greenLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
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
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF0D1F0D), // Dark forest background
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A3A1A), // Dark green card
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A3A1A).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF81C784)), // Light green
      titleTextStyle: const TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF81C784)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF81C784),
      secondary: Colors.green.shade300,
      surface: const Color(0xFF1A3A1A).withOpacity(0.8),
    ),
  );

  // Orange Theme - Sunset Orange for Light, Peach for Dark
  static final orangeLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
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
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: const Color(0xFF1F1206), // Dark amber background
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF3A2512), // Warm dark card
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF3A2512).withOpacity(0.8), // Semi-transparent
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFFB74D)), // Light orange
      titleTextStyle: const TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFFB74D)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFFFB74D), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFFFB74D),
      secondary: Colors.orange.shade300,
      surface: const Color(0xFF3A2512).withOpacity(0.8),
    ),
  );

  // Red Theme - Cherry Red for Light, Coral for Dark
  static final redLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.red),
      titleTextStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.red),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
      primary: Colors.red,
      secondary: Colors.redAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final redDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: const Color(0xFF1F0D0D),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF3A1A1A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF3A1A1A).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFEF5350)),
      titleTextStyle: const TextStyle(color: Color(0xFFEF5350), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFEF5350)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFEF5350), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFEF5350),
      secondary: Colors.red.shade300,
      surface: const Color(0xFF3A1A1A).withOpacity(0.8),
    ),
  );

  // Cyan Theme - Aqua Cyan for Light, Ice Blue for Dark
  static final cyanLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.cyan),
      titleTextStyle: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.cyan),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(
      primary: Colors.cyan,
      secondary: Colors.cyanAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final cyanDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.cyan,
    scaffoldBackgroundColor: const Color(0xFF0D1F1F),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A3A3A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A3A3A).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF4DD0E1)),
      titleTextStyle: const TextStyle(color: Color(0xFF4DD0E1), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF4DD0E1)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF4DD0E1), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF4DD0E1),
      secondary: Colors.cyan.shade300,
      surface: const Color(0xFF1A3A3A).withOpacity(0.8),
    ),
  );

  // Amber Theme - Golden Amber for Light, Honey for Dark
  static final amberLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.amber),
      titleTextStyle: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.amber),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber).copyWith(
      primary: Colors.amber,
      secondary: Colors.amberAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final amberDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: const Color(0xFF1F1A0D),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF3A3012),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF3A3012).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFFD54F)),
      titleTextStyle: const TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFFD54F)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFFFD54F), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFFFD54F),
      secondary: Colors.amber.shade300,
      surface: const Color(0xFF3A3012).withOpacity(0.8),
    ),
  );

  // Indigo Theme - Deep Indigo for Light, Violet for Dark
  static final indigoLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.indigo),
      titleTextStyle: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.indigo),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(
      primary: Colors.indigo,
      secondary: Colors.indigoAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final indigoDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: const Color(0xFF0D0D1F),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A1A3A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A3A).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF7986CB)),
      titleTextStyle: const TextStyle(color: Color(0xFF7986CB), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF7986CB)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF7986CB), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF7986CB),
      secondary: Colors.indigo.shade300,
      surface: const Color(0xFF1A1A3A).withOpacity(0.8),
    ),
  );

  // Teal Theme - Ocean Teal for Light, Turquoise for Dark
  static final tealLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.teal),
      titleTextStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.teal),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final tealDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF0D1F1A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A3A2D),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A3A2D).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF4DB6AC)),
      titleTextStyle: const TextStyle(color: Color(0xFF4DB6AC), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF4DB6AC)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF4DB6AC), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF4DB6AC),
      secondary: Colors.teal.shade300,
      surface: const Color(0xFF1A3A2D).withOpacity(0.8),
    ),
  );

  // Lime Theme - Bright Lime for Light, Electric Lime for Dark
  static final limeLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.lime,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.lime),
      titleTextStyle: const TextStyle(color: Colors.lime, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.lime),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.lime, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lime).copyWith(
      primary: Colors.lime,
      secondary: Colors.limeAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final limeDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.lime,
    scaffoldBackgroundColor: const Color(0xFF0F1F0D),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF263A1A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF263A1A).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFCDDC39)),
      titleTextStyle: const TextStyle(color: Color(0xFFCDDC39), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFCDDC39)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFCDDC39), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lime, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFCDDC39),
      secondary: Colors.lime.shade300,
      surface: const Color(0xFF263A1A).withOpacity(0.8),
    ),
  );

  // Deep Orange Theme - Vibrant Orange for Light, Sunset Orange for Dark
  static final deepOrangeLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.deepOrange),
      titleTextStyle: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.deepOrange),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(
      primary: Colors.deepOrange,
      secondary: Colors.deepOrangeAccent,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final deepOrangeDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: const Color(0xFF1F0F0A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF3A2012),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF3A2012).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFF7043)),
      titleTextStyle: const TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFF7043)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFFF7043), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFFF7043),
      secondary: Colors.deepOrange.shade300,
      surface: const Color(0xFF3A2012).withOpacity(0.8),
    ),
  );

  // Blue Grey Theme - Steel Blue for Light, Slate for Dark
  static final blueGreyLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.blueGrey),
      titleTextStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.blueGrey),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
      primary: Colors.blueGrey,
      secondary: Colors.blueGrey.shade300,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final blueGreyDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: const Color(0xFF0F1419),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1E2328),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E2328).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF90A4AE)),
      titleTextStyle: const TextStyle(color: Color(0xFF90A4AE), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF90A4AE)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF90A4AE), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF90A4AE),
      secondary: Colors.blueGrey.shade300,
      surface: const Color(0xFF1E2328).withOpacity(0.8),
    ),
  );

  // Brown Theme - Coffee Brown for Light, Chocolate for Dark
  static final brownLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.brown),
      titleTextStyle: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Colors.brown),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown).copyWith(
      primary: Colors.brown,
      secondary: Colors.brown.shade300,
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final brownDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFF1A0F0A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1B12),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1B12).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFA1887F)),
      titleTextStyle: const TextStyle(color: Color(0xFFA1887F), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFA1887F)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFA1887F), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.brown, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFA1887F),
      secondary: Colors.brown.shade300,
      surface: const Color(0xFF2D1B12).withOpacity(0.8),
    ),
  );

  // Crimson Theme - Rich Crimson for Light, Ruby for Dark
  static final crimsonLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFDC143C)),
      titleTextStyle: const TextStyle(color: Color(0xFFDC143C), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFDC143C)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFFDC143C), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
      primary: const Color(0xFFDC143C),
      secondary: const Color(0xFFB71C1C),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final crimsonDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: const Color(0xFF1A0A0A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1414),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1414).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFE57373)),
      titleTextStyle: const TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE57373)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFE57373),
      secondary: const Color(0xFFEF5350),
      surface: const Color(0xFF2D1414).withOpacity(0.8),
    ),
  );

  // Magenta Theme - Bright Magenta for Light, Hot Pink for Dark
  static final magentaLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
      titleTextStyle: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
      primary: const Color(0xFFE91E63),
      secondary: const Color(0xFFAD1457),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final magentaDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: const Color(0xFF1A0A14),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1425),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1425).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFF6EC7)),
      titleTextStyle: const TextStyle(color: Color(0xFFFF6EC7), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFF6EC7)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFFF6EC7), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFFF6EC7),
      secondary: const Color(0xFFE91E63),
      surface: const Color(0xFF2D1425).withOpacity(0.8),
    ),
  );

  // Violet Theme - Rich Violet for Light, Lavender for Dark
  static final violetLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF8E24AA)),
      titleTextStyle: const TextStyle(color: Color(0xFF8E24AA), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF8E24AA)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF8E24AA), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
      primary: const Color(0xFF8E24AA),
      secondary: const Color(0xFF7B1FA2),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final violetDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF0F0A1A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1F142D),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1F142D).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFCE93D8)),
      titleTextStyle: const TextStyle(color: Color(0xFFCE93D8), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFCE93D8)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFCE93D8), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFCE93D8),
      secondary: const Color(0xFFBA68C8),
      surface: const Color(0xFF1F142D).withOpacity(0.8),
    ),
  );

  // Turquoise Theme - Tropical Turquoise for Light, Aqua for Dark
  static final turquoiseLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF00BCD4)),
      titleTextStyle: const TextStyle(color: Color(0xFF00BCD4), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF00BCD4)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF00BCD4), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
      primary: const Color(0xFF00BCD4),
      secondary: const Color(0xFF00ACC1),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final turquoiseDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF0A1A1A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF142D2D),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF142D2D).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF26C6DA)),
      titleTextStyle: const TextStyle(color: Color(0xFF26C6DA), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF26C6DA)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF26C6DA), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF26C6DA),
      secondary: const Color(0xFF00BCD4),
      surface: const Color(0xFF142D2D).withOpacity(0.8),
    ),
  );

  // Gold Theme - Luxurious Gold for Light, Champagne for Dark
  static final goldLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.yellow,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
      titleTextStyle: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow).copyWith(
      primary: const Color(0xFFFFD700),
      secondary: const Color(0xFFFFC107),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final goldDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.yellow,
    scaffoldBackgroundColor: const Color(0xFF1A1A0A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D2D14),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D2D14).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFF9A825)),
      titleTextStyle: const TextStyle(color: Color(0xFFF9A825), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFF9A825)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFF9A825), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFF9A825),
      secondary: const Color(0xFFFFD700),
      surface: const Color(0xFF2D2D14).withOpacity(0.8),
    ),
  );

  // Silver Theme - Elegant Silver for Light, Platinum for Dark
  static final silverLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF757575)),
      titleTextStyle: const TextStyle(color: Color(0xFF757575), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF757575)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF757575), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey).copyWith(
      primary: const Color(0xFF757575),
      secondary: const Color(0xFF616161),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final silverDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF1A1A1A),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1A1A1A).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFBDBDBD)),
      titleTextStyle: const TextStyle(color: Color(0xFFBDBDBD), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFBDBDBD)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFBDBDBD), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFBDBDBD),
      secondary: const Color(0xFF9E9E9E),
      surface: const Color(0xFF1A1A1A).withOpacity(0.8),
    ),
  );

  // Emerald Theme - Rich Emerald for Light, Forest Green for Dark
  static final emeraldLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF009688)),
      titleTextStyle: const TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF009688)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF009688), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
      primary: const Color(0xFF009688),
      secondary: const Color(0xFF00695C),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final emeraldDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: const Color(0xFF0A1A14),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF142D1F),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF142D1F).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF26A69A)),
      titleTextStyle: const TextStyle(color: Color(0xFF26A69A), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF26A69A)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF26A69A), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF26A69A),
      secondary: const Color(0xFF009688),
      surface: const Color(0xFF142D1F).withOpacity(0.8),
    ),
  );

  // Ruby Theme - Deep Ruby for Light, Rose for Dark
  static final rubyLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF9A0036)),
      titleTextStyle: const TextStyle(color: Color(0xFF9A0036), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF9A0036)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF9A0036), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
      primary: const Color(0xFF9A0036),
      secondary: const Color(0xFF880E4F),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final rubyDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: const Color(0xFF1A0A0F),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1420),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1420).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
      titleTextStyle: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFE91E63),
      secondary: const Color(0xFFC2185B),
      surface: const Color(0xFF2D1420).withOpacity(0.8),
    ),
  );

  // Sapphire Theme - Deep Sapphire for Light, Sky Blue for Dark
  static final sapphireLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF003D82)),
      titleTextStyle: const TextStyle(color: Color(0xFF003D82), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF003D82)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF003D82), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      primary: const Color(0xFF003D82),
      secondary: const Color(0xFF1976D2),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final sapphireDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF0A0F1A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF14202D),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF14202D).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF42A5F5)),
      titleTextStyle: const TextStyle(color: Color(0xFF42A5F5), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF42A5F5)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF42A5F5), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF42A5F5),
      secondary: const Color(0xFF2196F3),
      surface: const Color(0xFF14202D).withOpacity(0.8),
    ),
  );

  // Coral Theme - Warm Coral for Light, Salmon for Dark
  static final coralLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFF5722)),
      titleTextStyle: const TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFF5722)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFFFF5722), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(
      primary: const Color(0xFFFF5722),
      secondary: const Color(0xFFE64A19),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final coralDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.deepOrange,
    scaffoldBackgroundColor: const Color(0xFF1A100A),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF2D1F14),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF2D1F14).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFFFF8A65)),
      titleTextStyle: const TextStyle(color: Color(0xFFFF8A65), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFFF8A65)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFFFF8A65), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFFFF8A65),
      secondary: const Color(0xFFFF5722),
      surface: const Color(0xFF2D1F14).withOpacity(0.8),
    ),
  );

  // Mint Theme - Fresh Mint for Light, Sage for Dark
  static final mintLightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Baloo',
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF00E676)),
      titleTextStyle: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF00E676)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
      primary: const Color(0xFF00E676),
      secondary: const Color(0xFF00C853),
      surface: Colors.white.withOpacity(0.8),
    ),
  );

  static final mintDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF0A1A14),
    fontFamily: 'Baloo',
    cardColor: const Color(0xFF142D20),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF142D20).withOpacity(0.8),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Color(0xFF69F0AE)),
      titleTextStyle: const TextStyle(color: Color(0xFF69F0AE), fontWeight: FontWeight.bold, fontSize: 22),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF69F0AE)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Color(0xFF69F0AE), fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal, brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF69F0AE),
      secondary: const Color(0xFF00E676),
      surface: const Color(0xFF142D20).withOpacity(0.8),
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
      case AppThemeType.red:
        return redLightTheme;
      case AppThemeType.cyan:
        return cyanLightTheme;
      case AppThemeType.amber:
        return amberLightTheme;
      case AppThemeType.indigo:
        return indigoLightTheme;
      case AppThemeType.teal:
        return tealLightTheme;
      case AppThemeType.lime:
        return limeLightTheme;
      case AppThemeType.deepOrange:
        return deepOrangeLightTheme;
      case AppThemeType.blueGrey:
        return blueGreyLightTheme;
      case AppThemeType.brown:
        return brownLightTheme;
      case AppThemeType.crimson:
        return crimsonLightTheme;
      case AppThemeType.magenta:
        return magentaLightTheme;
      case AppThemeType.violet:
        return violetLightTheme;
      case AppThemeType.turquoise:
        return turquoiseLightTheme;
      case AppThemeType.gold:
        return goldLightTheme;
      case AppThemeType.silver:
        return silverLightTheme;
      case AppThemeType.emerald:
        return emeraldLightTheme;
      case AppThemeType.ruby:
        return rubyLightTheme;
      case AppThemeType.sapphire:
        return sapphireLightTheme;
      case AppThemeType.coral:
        return coralLightTheme;
      case AppThemeType.mint:
        return mintLightTheme;
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
      case AppThemeType.red:
        return redDarkTheme;
      case AppThemeType.cyan:
        return cyanDarkTheme;
      case AppThemeType.amber:
        return amberDarkTheme;
      case AppThemeType.indigo:
        return indigoDarkTheme;
      case AppThemeType.teal:
        return tealDarkTheme;
      case AppThemeType.lime:
        return limeDarkTheme;
      case AppThemeType.deepOrange:
        return deepOrangeDarkTheme;
      case AppThemeType.blueGrey:
        return blueGreyDarkTheme;
      case AppThemeType.brown:
        return brownDarkTheme;
      case AppThemeType.crimson:
        return crimsonDarkTheme;
      case AppThemeType.magenta:
        return magentaDarkTheme;
      case AppThemeType.violet:
        return violetDarkTheme;
      case AppThemeType.turquoise:
        return turquoiseDarkTheme;
      case AppThemeType.gold:
        return goldDarkTheme;
      case AppThemeType.silver:
        return silverDarkTheme;
      case AppThemeType.emerald:
        return emeraldDarkTheme;
      case AppThemeType.ruby:
        return rubyDarkTheme;
      case AppThemeType.sapphire:
        return sapphireDarkTheme;
      case AppThemeType.coral:
        return coralDarkTheme;
      case AppThemeType.mint:
        return mintDarkTheme;
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
      case AppThemeType.red:
        return 'Cherry Red';
      case AppThemeType.cyan:
        return 'Aqua Cyan';
      case AppThemeType.amber:
        return 'Golden Amber';
      case AppThemeType.indigo:
        return 'Deep Indigo';
      case AppThemeType.teal:
        return 'Ocean Teal';
      case AppThemeType.lime:
        return 'Electric Lime';
      case AppThemeType.deepOrange:
        return 'Vibrant Orange';
      case AppThemeType.blueGrey:
        return 'Steel Grey';
      case AppThemeType.brown:
        return 'Coffee Brown';
      case AppThemeType.crimson:
        return 'Rich Crimson';
      case AppThemeType.magenta:
        return 'Hot Magenta';
      case AppThemeType.violet:
        return 'Royal Violet';
      case AppThemeType.turquoise:
        return 'Tropical Turquoise';
      case AppThemeType.gold:
        return 'Luxurious Gold';
      case AppThemeType.silver:
        return 'Elegant Silver';
      case AppThemeType.emerald:
        return 'Rich Emerald';
      case AppThemeType.ruby:
        return 'Deep Ruby';
      case AppThemeType.sapphire:
        return 'Deep Sapphire';
      case AppThemeType.coral:
        return 'Warm Coral';
      case AppThemeType.mint:
        return 'Fresh Mint';
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
      case AppThemeType.red:
        return Colors.red;
      case AppThemeType.cyan:
        return Colors.cyan;
      case AppThemeType.amber:
        return Colors.amber;
      case AppThemeType.indigo:
        return Colors.indigo;
      case AppThemeType.teal:
        return Colors.teal;
      case AppThemeType.lime:
        return Colors.lime;
      case AppThemeType.deepOrange:
        return Colors.deepOrange;
      case AppThemeType.blueGrey:
        return Colors.blueGrey;
      case AppThemeType.brown:
        return Colors.brown;
      case AppThemeType.crimson:
        return const Color(0xFFDC143C);
      case AppThemeType.magenta:
        return const Color(0xFFE91E63);
      case AppThemeType.violet:
        return const Color(0xFF8E24AA);
      case AppThemeType.turquoise:
        return const Color(0xFF00BCD4);
      case AppThemeType.gold:
        return const Color(0xFFFFD700);
      case AppThemeType.silver:
        return const Color(0xFF757575);
      case AppThemeType.emerald:
        return const Color(0xFF009688);
      case AppThemeType.ruby:
        return const Color(0xFF9A0036);
      case AppThemeType.sapphire:
        return const Color(0xFF003D82);
      case AppThemeType.coral:
        return const Color(0xFFFF5722);
      case AppThemeType.mint:
        return const Color(0xFF00E676);
    }
  }

  // Get the current theme color based on brightness
  static Color getCurrentThemeColor(AppThemeType themeType, bool isDarkMode) {
    switch (themeType) {
      case AppThemeType.pink:
        return isDarkMode ? _darkModeRose : _darkPink;
      case AppThemeType.blue:
        return isDarkMode ? const Color(0xFF64B5F6) : Colors.blue;
      case AppThemeType.purple:
        return isDarkMode ? const Color(0xFFBA68C8) : Colors.purple;
      case AppThemeType.green:
        return isDarkMode ? const Color(0xFF81C784) : Colors.green;
      case AppThemeType.orange:
        return isDarkMode ? const Color(0xFFFFB74D) : Colors.orange;
      case AppThemeType.red:
        return isDarkMode ? const Color(0xFFEF5350) : Colors.red;
      case AppThemeType.cyan:
        return isDarkMode ? const Color(0xFF4DD0E1) : Colors.cyan;
      case AppThemeType.amber:
        return isDarkMode ? const Color(0xFFFFD54F) : Colors.amber;
      case AppThemeType.indigo:
        return isDarkMode ? const Color(0xFF7986CB) : Colors.indigo;
      case AppThemeType.teal:
        return isDarkMode ? const Color(0xFF4DB6AC) : Colors.teal;
      case AppThemeType.lime:
        return isDarkMode ? const Color(0xFFCDDC39) : Colors.lime;
      case AppThemeType.deepOrange:
        return isDarkMode ? const Color(0xFFFF7043) : Colors.deepOrange;
      case AppThemeType.blueGrey:
        return isDarkMode ? const Color(0xFF90A4AE) : Colors.blueGrey;
      case AppThemeType.brown:
        return isDarkMode ? const Color(0xFFA1887F) : Colors.brown;
      case AppThemeType.crimson:
        return isDarkMode ? const Color(0xFFE57373) : const Color(0xFFDC143C);
      case AppThemeType.magenta:
        return isDarkMode ? const Color(0xFFFF6EC7) : const Color(0xFFE91E63);
      case AppThemeType.violet:
        return isDarkMode ? const Color(0xFFCE93D8) : const Color(0xFF8E24AA);
      case AppThemeType.turquoise:
        return isDarkMode ? const Color(0xFF26C6DA) : const Color(0xFF00BCD4);
      case AppThemeType.gold:
        return isDarkMode ? const Color(0xFFF9A825) : const Color(0xFFFFD700);
      case AppThemeType.silver:
        return isDarkMode ? const Color(0xFFBDBDBD) : const Color(0xFF757575);
      case AppThemeType.emerald:
        return isDarkMode ? const Color(0xFF26A69A) : const Color(0xFF009688);
      case AppThemeType.ruby:
        return isDarkMode ? const Color(0xFFE91E63) : const Color(0xFF9A0036);
      case AppThemeType.sapphire:
        return isDarkMode ? const Color(0xFF42A5F5) : const Color(0xFF003D82);
      case AppThemeType.coral:
        return isDarkMode ? const Color(0xFFFF8A65) : const Color(0xFFFF5722);
      case AppThemeType.mint:
        return isDarkMode ? const Color(0xFF69F0AE) : const Color(0xFF00E676);
    }
  }

  // For backward compatibility
  static ThemeData get lightTheme => pinkLightTheme;
  static ThemeData get darkTheme => pinkDarkTheme;
}
