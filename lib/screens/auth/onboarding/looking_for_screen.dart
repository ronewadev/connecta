import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/onboarding/preferences_screen.dart';
import 'package:connecta/services/profile_data_service.dart';
import 'package:connecta/models/user_model.dart';

class LookingForScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final List<File> images; // Change to List<File>
  final File profileImage;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final String bio;
  final UserLocation? userLocation;

  const LookingForScreen({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.nationality,
    required this.images, // Now List<File>
    required this.profileImage,
    required this.interests,
    required this.hobbies,
    required this.dealBreakers,
    required this.bio,
    this.userLocation,
  });

  @override
  State<LookingForScreen> createState() => _LookingForScreenState();
}

class _LookingForScreenState extends State<LookingForScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, Set<String>> _selectedByCategory = {
    'Relationship Type': {},
    'Personality': {},
    'Lifestyle': {},
    'Values': {},
  };
  
  // Different max selections per category
  final Map<String, int> _maxPerCategory = {
    'Relationship Type': 2,
    'Personality': 4,
    'Lifestyle': 4,
    'Values': 4,
  };

  // Dynamic data from Firestore
  Map<String, List<String>> _lookingForCategories = {};
  bool _isLoading = true;

  final Map<String, IconData> _categoryIcons = {
    'Relationship Type': FontAwesomeIcons.heart,
    'Personality': FontAwesomeIcons.user,
    'Lifestyle': FontAwesomeIcons.leaf,
    'Values': FontAwesomeIcons.star,
  };

  final Map<String, Color> _categoryColors = {
    'Relationship Type': const Color(0xFFEC4899),
    'Personality': const Color(0xFF9333EA),
    'Lifestyle': const Color(0xFF06B6D4),
    'Values': const Color(0xFF10B981),
  };

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileDataService.getAllProfileData();
      setState(() {
        _lookingForCategories = {
          'Relationship Type': profileData['relationship_types'] ?? [],
          'Personality': profileData['personality'] ?? [],
          'Lifestyle': profileData['lifestyle'] ?? [],
          'Values': profileData['values'] ?? [],
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B46C1),
              Color(0xFF9333EA),
              Color(0xFFEC4899),
              Color(0xFFBE185D),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              _buildProgressBar(),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Title
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.8)],
                            ).createShader(bounds),
                            child: const Text(
                              'What are you looking for?',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Help us find your perfect match by selecting your preferences',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  
                          const SizedBox(height: 32),

                          // Categories
                          ..._lookingForCategories.entries.map((entry) {
                            return Column(
                              children: [
                                _buildCategorySection(
                                  title: entry.key,
                                  items: entry.value,
                                  icon: _categoryIcons[entry.key]!,
                                  color: _categoryColors[entry.key]!,
                                  maxSelection: _maxPerCategory[entry.key]!,
                                ),
                                const SizedBox(height: 24),
                              ],
                            );
                          }).toList(),

                          const SizedBox(height: 100), // Extra spacing for button clearance
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Fixed Continue Button at bottom
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Make the section transparent
                ),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: _getTotalSelected() >= 6
                        ? const LinearGradient(
                      colors: [
                        Color(0xFFEC4899),
                        Color(0xFFBE185D),
                      ],
                    )
                        : LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.5),
                        Colors.grey.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: _getTotalSelected() >= 6
                        ? [
                      BoxShadow(
                        color: const Color(0xFFEC4899).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                        : null,
                  ),
                  child: ElevatedButton(
                    onPressed: _getTotalSelected() >= 6 ? _continueToNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getTotalSelected() >= 6 ? Colors.white : Colors.white.withOpacity(0.5),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                'Step 4 of 6',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: 0.67, // 4/6
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
    required int maxSelection,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.8),
                            color.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_selectedByCategory[title]?.length ?? 0}/$maxSelection selected',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Items Grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((item) {
                    final isSelected = _selectedByCategory[title]?.contains(item) ?? false;
                    final canSelect = (_selectedByCategory[title]?.length ?? 0) < maxSelection;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedByCategory[title]?.remove(item);
                          } else if (canSelect) {
                            _selectedByCategory[title]?.add(item);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [
                              color.withOpacity(0.8),
                              color.withOpacity(0.6),
                            ],
                          )
                              : LinearGradient(
                            colors: [
                              Colors.white.withOpacity(canSelect ? 0.2 : 0.1),
                              Colors.white.withOpacity(canSelect ? 0.1 : 0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? color.withOpacity(0.8)
                                : Colors.white.withOpacity(canSelect ? 0.3 : 0.15),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.white.withOpacity(canSelect || isSelected ? 1.0 : 0.5),
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      );
  }

  int _getTotalSelected() {
    return _selectedByCategory.values.fold(0, (sum, set) => sum + set.length);
  }

  List<String> _getAllSelected() {
    return _selectedByCategory.values.expand((set) => set).toList();
  }

  void _continueToNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PreferencesScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          gender: widget.gender,
          mobile: widget.mobile,
          nationality: widget.nationality,
          images: widget.images,
          interests: widget.interests,
          hobbies: widget.hobbies,
          dealBreakers: widget.dealBreakers,
          lookingFor: _getAllSelected(),
          bio: widget.bio,
          userLocation: widget.userLocation,
          profileImage: widget.profileImage,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}