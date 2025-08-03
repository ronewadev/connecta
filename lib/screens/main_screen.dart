import 'package:connecta/screens/chat/chat_screen.dart';
import 'package:connecta/screens/discover/discover_screen.dart';
import 'package:connecta/screens/home/live_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connecta/screens/home/meet_screen.dart';
import 'package:connecta/screens/home/call_screen.dart';
import 'package:connecta/screens/profile/profile_screen.dart';
import 'package:connecta/screens/settings/settings_screen.dart';
import 'package:connecta/widgets/custom_bottom_nav.dart';
import 'package:connecta/widgets/user_card.dart';
import 'package:connecta/services/user_service.dart';
import 'package:connecta/models/user_model.dart';

import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // Default to Home tab

  // Screens for bottom navigation
  // 0: Connecta
  // 1: Meet
  // 2: Live
  // 3: Home
  // 4: Chat
  // 5: Plans/Store
  // 6: Notification
  // 7: Profile
  final List<Widget> _bottomNavScreens = [
    const HomeScreen(),         // 0: Connecta
    const MeetScreen(),         // 1: Meet
    const LiveScreen(),         // 2: Live
    const HomeScreen(),         // 3: Home
    const ChatScreen(),         // 4: Chat
    const SettingsScreen(),     // 5: Plans/Store
    // Dummy Notification Screen
    Scaffold(
      body: Center(child: Text('Notifications', style: TextStyle(fontSize: 24))),
    ),
    const ProfileScreen(),      // 7: Profile (must be at the end)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBarForIndex(_currentIndex),
      body: _bottomNavScreens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBarForIndex(int index) {
    if (index == 3) return null; // Home tab: no app bar
    String title = 'Connecta';
    IconData? icon;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.pinkAccent, size: 28),
            const SizedBox(width: 10),
          ],
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.pink, CupertinoColors.systemPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Baloo',
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications screen coming soon!')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings screen coming soon!')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }

}