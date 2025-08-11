import 'dart:async';

import 'package:connecta/screens/chat/chat_screen.dart';
import 'package:connecta/screens/home/home_screen.dart';
import 'package:connecta/screens/plans/subscription_screen.dart';
import 'package:connecta/screens/profile/profile_screen.dart';
import 'package:connecta/screens/settings/settings_screen.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'likes/likes_screen.dart';
import 'live/live_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  User? _userData;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  final List<Widget> _bottomNavScreens = [
    const HomeScreen(),         // 0: Home (Meet/Call)
    const LiveScreen(),         // 1: Live
    const ChatScreen(),         // 2: Chat
    const LikesScreen(likedByUsers: [],),      // 3: Likes
    const SubscriptionScreen(),        // 4: Plans
  ];

  final List<String> _screenTitles = [
    AppText.appName,
    AppText.appName,
    AppText.appName,
    AppText.appName,
    AppText.appName,
  ];

  final List<IconData> _screenIcons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.video,
    FontAwesomeIcons.commentDots,
    FontAwesomeIcons.solidHeart,
    FontAwesomeIcons.crown,
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Set up real-time listener for current user
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            _userData = User.fromMap(snapshot.data()!, user.uid);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  // Helper method to get the profile image
  ImageProvider? _getProfileImage() {
    if (_userData == null) return null;

    // Check if profileImageUrl is available
    if (_userData!.profileImageUrl != null && _userData!.profileImageUrl!.isNotEmpty) {
      return NetworkImage(_userData!.profileImageUrl!);
    }


    // Check if profileImages array has items
    if (_userData!.profileImages.isNotEmpty) {
      final imageUrl = _userData!.profileImages.first;
      if (imageUrl.isNotEmpty) {
        return NetworkImage(imageUrl);
      }
    }

    // Return null to show the default icon
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _bottomNavScreens[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface.withAlpha(90),
                    theme.colorScheme.surface.withAlpha(70),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.primary.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: FaIcon(
                    _screenIcons[_currentIndex],
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    _screenTitles[_currentIndex],
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
      actions: [
        // Notifications icon with badge effect
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppText.notificationComingSoon)),
                  );
                },
              ),
              // Notification badge
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Settings icon with enhanced styling
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.1),
                theme.colorScheme.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.gear,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ),
        // Profile icon with avatar-like styling
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary,
              backgroundImage: _getProfileImage(),
              child: _getProfileImage() == null
                  ? FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
        ),
      ])
        ),
      ),
    );
  }
}