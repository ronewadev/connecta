import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/onboarding/link_social_screen.dart';
import 'package:connecta/services/profile_data_service.dart';
import 'package:connecta/models/user_model.dart';

class PreferencesScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final List<String> images;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final List<String> lookingFor;
  final String bio;
  final UserLocation? userLocation;
  final File profileImage;

  const PreferencesScreen({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.nationality,
    required this.images,
    required this.interests,
    required this.hobbies,
    required this.dealBreakers,
    required this.lookingFor,
    required this.bio,
    this.userLocation,
    required  this.profileImage,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Preference settings with default values
  RangeValues _ageRange = const RangeValues(18, 35);
  double _maxDistance = 25.0;
  Set<String> _selectedInterestedIn = <String>{};
  Set<String> _selectedRelationshipType = <String>{};
  Set<String> _selectedEducation = <String>{};
  Set<String> _selectedLifestyle = <String>{};
  bool _showOnline = false;
  bool _verifiedOnly = false;
  bool _photoRequired = false;

  final int _maxSelectionPerCategory = 2;

  // Dynamic data from Firestore
  List<String> _genderOptions = [];
  List<String> _relationshipOptions = [];
  List<String> _educationOptions = [];
  List<String> _lifestyleOptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Ensure distance is within valid range (5-50)
    if (_maxDistance < 5.0) {
      _maxDistance = 5.0;
    } else if (_maxDistance > 50.0) {
      _maxDistance = 50.0;
    }
    
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
        _genderOptions = ['Men', 'Women', 'Non-binary','Everyone'];
        _relationshipOptions = profileData['relationship_types'] ?? [];
        _educationOptions = profileData['education'] ?? [];
        _lifestyleOptions = profileData['lifestyle'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool get _canContinue {
    // Require at least one selection in each category
    return _selectedInterestedIn.isNotEmpty &&
           _selectedRelationshipType.isNotEmpty &&
           _selectedEducation.isNotEmpty &&
           _selectedLifestyle.isNotEmpty;
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
                              'Set Your Preferences',
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
                            'Help us find your perfect matches',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          
                          // Age Range
                          _buildPreferenceCard(
                            title: 'Age Range',
                            icon: FontAwesomeIcons.calendar,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Preferred age: ${_ageRange.start.round()} - ${_ageRange.end.round()} years',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                RangeSlider(
                                  values: _ageRange,
                                  min: 18,
                                  max: 60,
                                  divisions: 42,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white.withOpacity(0.3),
                                  onChanged: (values) {
                                    setState(() {
                                      _ageRange = values;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Distance
                          _buildPreferenceCard(
                            title: 'Maximum Distance',
                            icon: FontAwesomeIcons.locationDot,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Within ${_maxDistance.round()} km',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Slider(
                                  value: _maxDistance.clamp(5.0, 50.0),
                                  min: 5,
                                  max: 50,
                                  divisions: 45,
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.white.withOpacity(0.3),
                                  onChanged: (value) {
                                    setState(() {
                                      _maxDistance = value.clamp(5.0, 50.0);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Interested In
                          _buildSelectionSection(
                            title: 'Interested In',
                            subtitle: 'Select 1 preference',
                            icon: FontAwesomeIcons.heart,
                            items: _genderOptions,
                            selectedItems: _selectedInterestedIn,
                            maxSelection: 1,
                            color: const Color(0xFFEC4899),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Relationship Type
                          _buildSelectionSection(
                            title: 'Looking For',
                            subtitle: 'Select 1-2 preferences',
                            icon: FontAwesomeIcons.users,
                            items: _relationshipOptions,
                            selectedItems: _selectedRelationshipType,
                            maxSelection: _maxSelectionPerCategory,
                            color: const Color(0xFF9333EA),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Education Preferences
                          _buildSelectionSection(
                            title: 'Education Level',
                            subtitle: 'Select 1-2 preferences',
                            icon: FontAwesomeIcons.graduationCap,
                            items: _educationOptions,
                            selectedItems: _selectedEducation,
                            maxSelection: _maxSelectionPerCategory,
                            color: const Color(0xFF06B6D4),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Lifestyle Preferences
                          _buildSelectionSection(
                            title: 'Lifestyle',
                            subtitle: 'Select 1-2 preferences',
                            icon: FontAwesomeIcons.leaf,
                            items: _lifestyleOptions,
                            selectedItems: _selectedLifestyle,
                            maxSelection: _maxSelectionPerCategory,
                            color: const Color(0xFF10B981),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Additional Filters
                          _buildPreferenceCard(
                            title: 'Additional Filters',
                            icon: FontAwesomeIcons.filter,
                            child: Column(
                              children: [
                                SwitchListTile(
                                  title: const Text(
                                    'Show online users first',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Prioritize active users',
                                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  ),
                                  value: _showOnline,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      _showOnline = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text(
                                    'Verified profiles only',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Only show verified users',
                                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  ),
                                  value: _verifiedOnly,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      _verifiedOnly = value;
                                    });
                                  },
                                ),
                                SwitchListTile(
                                  title: const Text(
                                    'Photo required',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Only show profiles with photos',
                                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  ),
                                  value: _photoRequired,
                                  activeColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      _photoRequired = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          
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
                    gradient: _canContinue
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
                    boxShadow: _canContinue
                        ? [
                            BoxShadow(
                              color: const Color(0xFFEC4899).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    onPressed: _canContinue ? _continueToNextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                          size: 20,
                                  ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                 ] ),
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
                'Step 5 of 6',
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
            value: 0.83, // 5/6
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required Set<String> selectedItems,
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
                                  // For single selection (maxSelection = 1), clear previous selections
                                  if (maxSelection == 1) {
                                    selectedItems.clear();
                                  }
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

  Widget _buildPreferenceCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
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
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: FaIcon(
                            icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _continueToNextStep() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LinkSocialScreen(
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
          lookingFor: widget.lookingFor,
          bio: widget.bio,
          userLocation: widget.userLocation,
          profileImage: widget.profileImage,
          // Pass the selected preferences as lists
          ageRange: [_ageRange.start.round(), _ageRange.end.round()],
          maxDistance: _maxDistance.round(),
          interestedIn: _selectedInterestedIn.toList(),
          relationshipType: _selectedRelationshipType.toList(),
          education: _selectedEducation.toList(),
          lifestyle: _selectedLifestyle.toList(),
          showOnline: _showOnline,
          verifiedOnly: _verifiedOnly,
          photoRequired: _photoRequired,
        ),
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
