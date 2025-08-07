import 'package:connecta/screens/settings/theme_selector_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connecta/providers/theme_provider.dart';
import 'package:connecta/screens/settings/widgets/settings_tile.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppText.settings,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Account Section
                _buildSectionHeader(theme, 'Account', FontAwesomeIcons.user),
                const SizedBox(height: 16),
            SettingsTile(
              icon: FontAwesomeIcons.userPen,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            SettingsTile(
              icon: FontAwesomeIcons.shield,
              title: 'Privacy & Security',
              subtitle: 'Control your privacy settings',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            SettingsTile(
              icon: FontAwesomeIcons.bell,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            
            const SizedBox(height: 32),

            // Appearance Section
            _buildSectionHeader(theme, 'Appearance', FontAwesomeIcons.palette),
            const SizedBox(height: 16),
            SettingsTile(
              icon: FontAwesomeIcons.palette,
              title: 'App Theme',
              subtitle: 'Currently: ${themeProvider.currentThemeName}',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ThemeSelectorScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: themeProvider.isDarkMode ? FontAwesomeIcons.sun : FontAwesomeIcons.moon,
              title: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              subtitle: 'Currently in ${themeProvider.isDarkMode ? 'Dark' : 'Light'} mode',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: themeProvider.currentThemeColor,
              ),
              onTap: () {
                themeProvider.toggleTheme();
              },
            ),
            const SizedBox(height: 32),

            // Connecta Section
            _buildSectionHeader(theme, 'Connecta', FontAwesomeIcons.heart),
            const SizedBox(height: 16),
            SettingsTile(
              icon: FontAwesomeIcons.circleQuestion,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            SettingsTile(
              icon: FontAwesomeIcons.circleInfo,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            const SizedBox(height: 32),          // Logout Button
          SettingsTile(
            icon: FontAwesomeIcons.rightFromBracket,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            color: Colors.red,
            onTap: () {
              // Handle logout
            },
          ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FaIcon(
              icon,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}