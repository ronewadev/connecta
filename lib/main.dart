import 'package:connecta/providers/theme_provider.dart';
import 'package:connecta/screens/auth/welcome_screen.dart';
import 'package:connecta/screens/main_screen.dart';
import 'package:connecta/services/subscriptions/subscription_services.dart';
import 'package:connecta/utils/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreferences();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (context) => SubscriptionService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (themeProvider.isLoading) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: AppThemes.getThemeColor(AppThemeType.pink),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        return AnimatedTheme(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          data: themeProvider.isDarkMode 
              ? themeProvider.darkTheme 
              : themeProvider.lightTheme,
          child: MaterialApp(
            title: 'Connecta',
            themeMode: themeProvider.themeMode,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            home: const WelcomeScreen(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}