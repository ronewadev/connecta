import 'dart:ui';

class AppTheme {
  final String id;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color textColor;
  final String? iconPath;
  final int cost; // in tokens
  final bool changesAppIcon;
  final bool isPremium;

  AppTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.textColor,
    this.iconPath,
    this.cost = 0,
    this.changesAppIcon = false,
    this.isPremium = false,
  });
}