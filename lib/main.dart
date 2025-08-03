import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/services/theme_service.dart';
import 'package:connecta/screens/auth/welcome_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Connecta',
      theme: ThemeData(
        primaryColor: themeService.currentTheme.primaryColor,
        scaffoldBackgroundColor: themeService.currentTheme.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: themeService.currentTheme.textColor),
          bodyMedium: TextStyle(color: themeService.currentTheme.textColor),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: themeService.currentTheme.primaryColor,
          titleTextStyle: TextStyle(
            color: themeService.currentTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}