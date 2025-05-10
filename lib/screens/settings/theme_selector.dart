import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/models/theme_model.dart';
import 'package:connecta/services/theme_service.dart';
import 'package:connecta/widgets/theme_preview_card.dart';

class ThemeSelectorScreen extends StatelessWidget {
  const ThemeSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final availableThemes = themeService.availableThemes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theme'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Themes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium themes require tokens to unlock',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: availableThemes.length,
                itemBuilder: (context, index) {
                  final theme = availableThemes[index];
                  return ThemePreviewCard(
                    theme: theme,
                    isSelected: theme.id == themeService.currentTheme.id,
                    onTap: () {
                      if (!theme.isPremium || _hasEnoughTokens(context, theme)) {
                        themeService.changeTheme(theme);
                      } else {
                        _showPremiumDialog(context, theme);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasEnoughTokens(BuildContext context, AppTheme theme) {
    // Implement your token check logic here
    // Example:
    // final tokenService = Provider.of<TokenService>(context);
    // return tokenService.currentTokens >= theme.cost;
    return true; // Temporarily returning true for testing
  }

  void _showPremiumDialog(BuildContext context, AppTheme theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Premium Theme: ${theme.name}'),
        content: Text(
          'This theme requires ${theme.cost} tokens to unlock. '
              'Would you like to purchase it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement purchase logic
              // After successful purchase:
              // themeService.changeTheme(theme);
            },
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }
}