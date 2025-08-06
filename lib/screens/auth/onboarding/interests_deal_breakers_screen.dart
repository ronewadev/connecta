import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/onboarding/looking_for_screen.dart';

class InterestsDealbrakersScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final int avatarIndex;
  final List<String> images;

  const InterestsDealbrakersScreen({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.nationality,
    required this.avatarIndex,
    required this.images,
  });

  @override
  State<InterestsDealbrakersScreen> createState() => _InterestsDealbrakersScreenState();
}

class _InterestsDealbrakersScreenState extends State<InterestsDealbrakersScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Set<String> _selectedInterests = {};
  Set<String> _selectedHobbies = {};
  Set<String> _selectedDealBreakers = {};

  final int _minInterests = 2;
  final int _maxInterests = 5;
  final int _minHobbies = 2;
  final int _maxHobbies = 5;
  final int _minDealBreakers = 2;
  final int _maxDealBreakers = 3;

  final List<String> _interests = [
    'Photography', 'Travel', 'Music', 'Dancing', 'Reading', 'Movies', 'Art', 'Cooking',
    'Sports', 'Gaming', 'Fashion', 'Technology', 'Nature', 'Animals', 'Cars', 'Food',
    'Wine', 'Coffee', 'Yoga', 'Meditation', 'History', 'Science', 'Politics', 'Business'
  ];

  final List<String> _hobbies = [
    'Hiking', 'Swimming', 'Cycling', 'Running', 'Gym', 'Rock Climbing', 'Surfing', 'Skiing',
    'Painting', 'Drawing', 'Writing', 'Singing', 'Playing Guitar', 'Piano', 'Crafting', 'Gardening',
    'Board Games', 'Video Games', 'Chess', 'Poker', 'Fishing', 'Camping', 'Astronomy', 'Collecting'
  ];

  final List<String> _dealBreakers = [
    'Smoking', 'Heavy Drinking', 'Drug Use', 'Dishonesty', 'Rudeness', 'Poor Hygiene',
    'Arrogance', 'Jealousy', 'Controlling Behavior', 'Lack of Ambition', 'Infidelity', 'Violence',
    'Extreme Political Views', 'Religious Intolerance', 'Financial Irresponsibility', 'Laziness'
  ];

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6B46C1),
              const Color(0xFF9333EA),
              const Color(0xFFEC4899),
              const Color(0xFFBE185D),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.8)],
                            ).createShader(bounds),
                            child: const Text(
                              'Interests & Preferences',
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
                            'Help us find your perfect match',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildSection(
                            title: 'Interests',
                            subtitle: 'Select 2-5 interests',
                            icon: FontAwesomeIcons.heart,
                            items: _interests,
                            selectedItems: _selectedInterests,
                            minSelection: _minInterests,
                            maxSelection: _maxInterests,
                            color: const Color(0xFFEC4899),
                          ),
                          const SizedBox(height: 32),
                          _buildSection(
                            title: 'Hobbies',
                            subtitle: 'Select 2-5 hobbies',
                            icon: FontAwesomeIcons.gamepad,
                            items: _hobbies,
                            selectedItems: _selectedHobbies,
                            minSelection: _minHobbies,
                            maxSelection: _maxHobbies,
                            color: const Color(0xFF9333EA),
                          ),
                          const SizedBox(height: 32),
                          _buildSection(
                            title: 'Deal Breakers',
                            subtitle: 'Select 2-3 deal breakers',
                            icon: FontAwesomeIcons.ban,
                            items: _dealBreakers,
                            selectedItems: _selectedDealBreakers,
                            minSelection: _minDealBreakers,
                            maxSelection: _maxDealBreakers,
                            color: const Color(0xFFDC2626),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: _canContinue()
                                  ? LinearGradient(
                                      colors: [
                                        const Color(0xFFEC4899),
                                        const Color(0xFFBE185D),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey.withOpacity(0.5),
                                        Colors.grey.withOpacity(0.3),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: _canContinue()
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
                              onPressed: _canContinue() ? _continueToNext : null,
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
                                  color: _canContinue() ? Colors.white : Colors.white.withOpacity(0.5),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
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
                'Step 3 of 6',
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
            value: 0.5, // 3/6
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required Set<String> selectedItems,
    required int minSelection,
    required int maxSelection,
    required Color color,
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
                            '$subtitle (${selectedItems.length}/$maxSelection)',
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
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: items.map((item) {
                    final isSelected = selectedItems.contains(item);
                    final canSelect = selectedItems.length < maxSelection;
                    final disable = !isSelected && !canSelect;
                    return GestureDetector(
                      onTap: disable
                          ? null
                          : () {
                              setState(() {
                                if (isSelected) {
                                  selectedItems.remove(item);
                                } else if (canSelect) {
                                  selectedItems.add(item);
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
                                    Colors.white.withOpacity(disable ? 0.1 : 0.2),
                                    Colors.white.withOpacity(disable ? 0.05 : 0.1),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? color.withOpacity(0.8)
                                : Colors.white.withOpacity(disable ? 0.15 : 0.3),
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
                            color: disable
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white,
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

  bool _canContinue() {
    return _selectedInterests.length >= _minInterests &&
           _selectedHobbies.length >= _minHobbies &&
           _selectedDealBreakers.length >= _minDealBreakers;
  }

  void _continueToNext() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LookingForScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          gender: widget.gender,
          mobile: widget.mobile,
          nationality: widget.nationality,
          avatarIndex: widget.avatarIndex,
          images: widget.images,
          interests: _selectedInterests.toList(),
          hobbies: _selectedHobbies.toList(),
          dealBreakers: _selectedDealBreakers.toList(),
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
