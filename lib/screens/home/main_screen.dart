import 'package:flutter/material.dart';
import 'package:connecta/screens/home/meet_screen.dart';
import 'package:connecta/screens/home/call_screen.dart';
import 'package:connecta/screens/profile/profile_screen.dart';
import 'package:connecta/screens/settings/settings_screen.dart';
import 'package:connecta/widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // For bottom navigation
  bool _isMeetMode = true; // For Meet/Call toggle

  // Screens for bottom navigation
  final List<Widget> _bottomNavScreens = [
    const Placeholder(), // Will be replaced by Meet/Call
    Container(color: Colors.green), // Discover screen
    Container(color: Colors.blue), // Messages screen
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // Show Meet or Call screen when in Home (index 0), others from bottomNavScreens
      body: _currentIndex == 0
          ? _isMeetMode ? const MeetScreen() : const CallScreen()
          : _bottomNavScreens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.filter_alt),
        onPressed: () {
          // Show filter options
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Filter options coming soon!')),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, ),
          onPressed: () {
            // Show notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications screen coming soon!')),
            );
          },
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
          ),
          onPressed: () {
            // Go to profile screen
            setState(() => _currentIndex = 3); // Profile is at index 3
          },
        ),
      ],
      title: _buildMeetCallToggle(),
      centerTitle: true,
    );
  }

  Widget _buildMeetCallToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (!_isMeetMode) {
                setState(() => _isMeetMode = true);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isMeetMode ? Colors.pink : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Meet',
                style: TextStyle(
                  color: _isMeetMode ? Colors.white : Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_isMeetMode) {
                setState(() => _isMeetMode = false);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: !_isMeetMode ? Colors.pink : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Call',
                style: TextStyle(
                  color: !_isMeetMode ? Colors.white : Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}