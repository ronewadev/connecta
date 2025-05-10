import 'package:connecta/screens/settings/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/services/theme_service.dart';
import 'package:connecta/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          const Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              // Navigate to edit profile
            },
          ),
          SettingsTile(
            icon: Icons.security,
            title: 'Privacy',
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          const SizedBox(height: 24),

          // Appearance Section
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            icon: Icons.color_lens,
            title: 'App Theme',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSelectorScreen(),
                ),
              );
            },
          ),
          SettingsTile(
            icon: Icons.brightness_6,
            title: 'Dark Mode',
            trailing: Switch(
              value: themeService.currentTheme.id == 'dark',
              onChanged: (value) {
                themeService.changeTheme(
                  value
                      ? themeService.availableThemes.firstWhere(
                          (theme) => theme.id == 'dark')
                      : themeService.availableThemes.firstWhere(
                          (theme) => theme.id == 'default'),
                );
              },
            ), onTap: () {  },
          ),
          const SizedBox(height: 24),

          // Connecta Section
          const Text(
            'Connecta',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SettingsTile(
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // Navigate to help screen
            },
          ),
          SettingsTile(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // Navigate to about screen
            },
          ),
          const SizedBox(height: 24),

          // Logout Button
          SettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            color: Colors.red,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }
}