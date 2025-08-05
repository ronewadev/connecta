import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/home/meet_screen.dart';
import 'package:connecta/screens/home/call_screen.dart';
import 'package:connecta/utils/text_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMeetMode = true; // For Meet/Call toggle

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Modern toggle with theme support
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: _buildMeetCallToggle(theme),
          ),
          Expanded(
            child: _isMeetMode
                ? const MeetScreen()
                : const CallScreen(),
          ),
        ],
      ),
    );
  }



  Widget _buildMeetCallToggle(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            theme: theme,
            text: AppText.meet,
            icon: FontAwesomeIcons.fire,
            isActive: _isMeetMode,
            onTap: () {
              if (!_isMeetMode) {
                setState(() => _isMeetMode = true);
              }
            },
          ),
          _buildToggleButton(
            theme: theme,
            text: AppText.call,
            icon: FontAwesomeIcons.video,
            isActive: !_isMeetMode,
            onTap: () {
              if (_isMeetMode) {
                setState(() => _isMeetMode = false);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required ThemeData theme,
    required String text,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 16,
              color: isActive
                  ? Colors.white
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isActive
                    ? Colors.white
                    : theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}