import 'package:flutter/material.dart';
import 'package:connecta/screens/home/meet_screen.dart';
import 'package:connecta/screens/home/call_screen.dart';
import 'package:connecta/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMeetMode = true; // For Meet/Call toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: _buildMeetCallToggle(),
          ),
          Expanded(
            child: _isMeetMode
                ? MeetScreen()
                : CallScreen(),
          ),
        ],
      ),
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