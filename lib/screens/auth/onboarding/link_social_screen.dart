import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/main_screen.dart';
import 'package:connecta/services/auth_service.dart';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/database/user_database.dart';
import 'package:provider/provider.dart';

import '../../../services/upload_images.dart';

class LinkSocialScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final List<File> images; // Change from List<String> to List<File>
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final List<String> lookingFor;
  final String bio;
  final UserLocation? userLocation;
  // New preference parameters
  final List<int> ageRange;
  final int maxDistance;
  final List<String> interestedIn;
  //final List<String> relationshipType;
  final List<String> education;
  //final List<String> lifestyle;
  final bool showOnline;
  final bool verifiedOnly;
  final bool photoRequired;
  final File profileImage; // Add this

  const LinkSocialScreen({
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
    required this.ageRange,
    required this.maxDistance,
    required this.interestedIn,
    //required this.relationshipType,
    required this.education,
    //required this.lifestyle,
    required this.showOnline,
    required this.verifiedOnly,
    required this.photoRequired,
    required this.profileImage, // Add this
  });

  @override
  State<LinkSocialScreen> createState() => _LinkSocialScreenState();
}

class _LinkSocialScreenState extends State<LinkSocialScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Map<String, bool> _linkedPlatforms = {
    'Instagram': false,
    'TikTok': false,
    'Snapchat': false,
    'X': false,
    'Facebook': false,
    'WhatsApp': false,
  };

  Map<String, String> _platformLinks = {
    'Instagram': '',
    'TikTok': '',
    'Snapchat': '',
    'X': '',
    'Facebook': '',
    'WhatsApp': '',
  };

  final Map<String, TextEditingController> _linkControllers = {};

  bool _allowDirectContact = false;
  bool _isCreatingProfile = false;

  // Add this as a class variable
  double _uploadProgress = 0.0;

  final Map<String, IconData> _platformIcons = {
    'Instagram': FontAwesomeIcons.instagram,
    'TikTok': FontAwesomeIcons.tiktok,
    'Snapchat': FontAwesomeIcons.snapchat,
    'X': FontAwesomeIcons.xTwitter,
    'Facebook': FontAwesomeIcons.facebook,
    'WhatsApp': FontAwesomeIcons.whatsapp,
  };

  final Map<String, Color> _platformColors = {
    'Instagram': const Color(0xFFE4405F),
    'TikTok': const Color(0xFF000000),
    'Snapchat': const Color(0xFFFFFC00),
    'X': const Color(0xFF131313),
    'Facebook': const Color(0xFF1877F3),
    'WhatsApp': const Color(0xFF25D366),
  };

  // Remove all LinkedSocials and socialMediaLinks logic.
  // Instead, build a socialMedia map for Firestore.

  Map<String, Map<String, dynamic>> _socialMedia = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize text controllers for each platform
    for (String platform in _linkedPlatforms.keys) {
      _linkControllers[platform] = TextEditingController();
    }
    
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
              // Progress Bar
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
                          
                          // Title
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.8)],
                            ).createShader(bounds),
                            child: const Text(
                              'Link Your Socials',
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
                            'Connect your social accounts to add more personality (Optional)',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          
                          // Social Platforms
                          ClipRRect(
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
                                    children: [
                                      // Header
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  const Color(0xFFEC4899).withOpacity(0.8),
                                                  const Color(0xFFBE185D).withOpacity(0.6),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(24),
                                            ),
                                            child: const Center(
                                              child: FaIcon(
                                                FontAwesomeIcons.link,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          const Expanded(
                                            child: Text(
                                              'Social Platforms',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      
                                      // Platform Options
                                      ..._linkedPlatforms.entries.map((entry) {
                                        return _buildPlatformOption(
                                          platform: entry.key,
                                          isLinked: entry.value,
                                          icon: _platformIcons[entry.key]!,
                                          color: _platformColors[entry.key]!,
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Direct Contact Option
                          if (_linkedPlatforms.values.any((linked) => linked))
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
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
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _allowDirectContact,
                                              onChanged: (value) {
                                                setState(() {
                                                  _allowDirectContact = value ?? false;
                                                });
                                              },
                                              activeColor: const Color(0xFFEC4899),
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty.resolveWith((states) {
                                                if (states.contains(MaterialState.selected)) {
                                                  return const Color(0xFFEC4899);
                                                }
                                                return Colors.transparent;
                                              }),
                                              side: BorderSide(
                                                color: Colors.white.withOpacity(0.6),
                                                width: 2,
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Allow direct contact',
                                                    style: TextStyle(
                                                      color: Colors.white.withOpacity(0.9),
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Other users can contact you directly via linked platforms',
                                                    style: TextStyle(
                                                      color: Colors.white.withOpacity(0.7),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _showDirectContactInfo,
                                              icon: FaIcon(
                                                FontAwesomeIcons.circleInfo,
                                                color: Colors.white.withOpacity(0.7),
                                                size: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          
                          // Complete Profile Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFEC4899),
                                  const Color(0xFFBE185D),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFEC4899).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isCreatingProfile ? null : _completeProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: _isCreatingProfile
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const FaIcon(
                                          FontAwesomeIcons.rocket,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Complete Profile',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
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
                'Step 6 of 6',
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
            value: 1.0,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformOption({
    required String platform,
    required bool isLinked,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLinked 
              ? color.withOpacity(0.6) 
              : Colors.white.withOpacity(0.3),
          width: isLinked ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
        title: Text(
          platform,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          isLinked ? 'Connected' : 'Tap to connect',
          style: TextStyle(
            color: isLinked 
                ? color.withOpacity(0.8) 
                : Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        trailing: isLinked
            ? Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              )
            : FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white.withOpacity(0.6),
                size: 16,
              ),
        onTap: () => _togglePlatform(platform),
      ),
    );
  }

  void _togglePlatform(String platform) {
    if (_linkedPlatforms[platform]!) {
      setState(() {
        _linkedPlatforms[platform] = false;
        _platformLinks[platform] = '';
        _linkControllers[platform]!.clear();
        _socialMedia.remove(platform.toLowerCase());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$platform disconnected'),
          backgroundColor: const Color(0xFF6B46C1),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      _showLinkDialog(platform);
    }
  }

  void _showLinkDialog(String platform) {
    String hint = '';
    String example = '';
    
    switch (platform) {
      case 'WhatsApp':
        hint = 'Enter your WhatsApp number';
        example = 'e.g., 27792818288';
        break;
      case 'Instagram':
        hint = 'Enter your Instagram username';
        example = 'e.g., @username';
        break;
      case 'TikTok':
        hint = 'Enter your TikTok username';
        example = 'e.g., @username';
        break;
      case 'Snapchat':
        hint = 'Enter your Snapchat username';
        example = 'e.g., username';
        break;
      case 'X':
        hint = 'Enter your X (Twitter) handle';
        example = 'e.g., @username';
        break;
      case 'Facebook':
        hint = 'Enter your Facebook profile URL or username';
        example = 'e.g., facebook.com/username';
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6B46C1).withOpacity(0.95),
                const Color(0xFF9333EA).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _platformColors[platform]!.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with platform icon and title
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _platformColors[platform]!,
                          _platformColors[platform]!.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _platformColors[platform]!.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        _platformIcons[platform]!,
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
                          'Link $platform',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Connect your $platform profile',
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
              
              const SizedBox(height: 24),
              
              // Input field with beautiful styling
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _linkControllers[platform],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 16,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: FaIcon(
                        _platformIcons[platform]!,
                        color: _platformColors[platform]!.withOpacity(0.8),
                        size: 18,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: platform == 'WhatsApp' 
                      ? TextInputType.phone 
                      : TextInputType.text,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Example text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.lightbulb,
                      color: Colors.amber.withOpacity(0.8),
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        example,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _platformColors[platform]!,
                            _platformColors[platform]!.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _platformColors[platform]!.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          String input = _linkControllers[platform]!.text.trim();
                          if (input.isNotEmpty) {
                            setState(() {
                              _linkedPlatforms[platform] = true;
                              // Save to _socialMedia map
                              _socialMedia[platform.toLowerCase()] = {
                                'isLinked': true,
                                'link': input,
                              };
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.checkCircle,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 12),
                                    Text('$platform linked successfully!'),
                                  ],
                                ),
                                backgroundColor: const Color(0xFF4CAF50),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.link,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Link Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showDirectContactInfo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6B46C1).withOpacity(0.95),
                const Color(0xFF9333EA).withOpacity(0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEC4899).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFEC4899),
                      const Color(0xFFBE185D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC4899).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.circleInfo,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'Direct Contact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'When enabled, other users will be able to contact you directly through your linked social platforms. This adds more ways to connect but also shares your social profiles with matches.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFEC4899),
                      const Color(0xFFBE185D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEC4899).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Got it!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

Future<void> _completeProfile() async {
  setState(() {
    _isCreatingProfile = true;
  });

  try {
    print('🚀 Starting complete profile creation process...');

    // Show progress message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 12),
            Text('Creating your account...'),
          ],
        ),
        backgroundColor: const Color(0xFF6B46C1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 10),
      ),
    );

    final authService = Provider.of<AuthService>(context, listen: false);

    // Step 1: Create Firebase user account FIRST
    print('📤 Step 1: Creating Firebase user account...');
    
    Map<String, dynamic> result;
    
    try {
      result = await authService.signUp(
        email: widget.email,
        password: widget.password,
        username: widget.username,
      );
    } catch (e) {
      String errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('email address is already in use') || 
          errorMessage.contains('already exists')) {
        // If user already exists, try to sign in instead
        print('👤 User already exists, attempting to sign in...');
        result = await authService.signIn(
          email: widget.email,
          password: widget.password,
        );
      } else {
        rethrow;
      }
    }

    if (!result['success']) {
      throw Exception('Failed to authenticate: ${result['message']}');
    }
    print('✅ Firebase user authenticated');

    // Step 2: Send email verification
    try {
      print('📤 Step 2: Sending email verification...');
      await authService.sendEmailVerification();
      print('✅ Email verification sent');
    } catch (e) {
      print('⚠️  Email verification already sent or failed: $e');
      // Don't fail the whole process if email verification fails
    }

    // Update progress message
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                value: _uploadProgress, // Show actual progress
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 12),
            Text('Uploading photos... ${(_uploadProgress * 100).toStringAsFixed(0)}%'),
          ],
        ),
        backgroundColor: const Color(0xFF6B46C1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 30), // Longer duration for upload
      ),
    );

    // Step 3: Upload profile image (now user is authenticated)
    print('📤 Step 3: Uploading profile image...');
    final profileImageUrl = await ImageUploadService.uploadProfileImage(widget.profileImage);
    
    if (profileImageUrl == null) {
      throw Exception('Failed to upload profile image');
    }
    print('✅ Profile image uploaded: $profileImageUrl');

    // Step 4: Upload gallery images
    print('📤 Step 4: Uploading gallery images...');
    setState(() {
      _uploadProgress = 0.0;
    });

    final List<String> galleryImageUrls = await ImageUploadService.uploadGalleryImages(
      widget.images,
      onProgress: (progress) {
        setState(() {
          _uploadProgress = progress;
        });
        print('🔄 Gallery upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      },
    );
    print('✅ Gallery images uploaded: ${galleryImageUrls.length} images');

  
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            SizedBox(width: 12),
            Text('Finalizing your profile...'),
          ],
        ),
        backgroundColor: const Color(0xFF6B46C1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 10),
      ),
    );
    List<String> linkedSocialsList = _linkedPlatforms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final completeUser = UserModelInfo(
      id: '', 
      username: widget.username,
      email: widget.email,
      phone: widget.mobile.isNotEmpty ? widget.mobile : null,
      age: widget.age,
      gender: widget.gender,
      nationality: widget.nationality,
      location: widget.userLocation?.city ?? widget.nationality,
      userLocation: widget.userLocation,
      profileImageUrl: profileImageUrl, 
      profileImages: galleryImageUrls, 
      interests: widget.interests,
      hobbies: widget.hobbies,
      dealBreakers: widget.dealBreakers,
      bio: widget.bio,
      socialMedia: _socialMedia,
      allowDirectContact: _allowDirectContact,
      subscription: UserSubscription(type: 'basic', status: 'active'), // Create proper UserSubscription
      userBalance: UserBalance(), 
      preferences: {
        'ageRange': widget.ageRange,
        'maxDistance': widget.maxDistance,
        'interestedIn': widget.interestedIn,
//        'relationshipType': widget.relationshipType,
        'education': widget.education,
       // 'lifestyle': widget.lifestyle,
        'showOnline': widget.showOnline,
        'verifiedOnly': widget.verifiedOnly,
        'photoRequired': widget.photoRequired,
        'dealBreakers': widget.dealBreakers,
        'allowDirectContact': _allowDirectContact,
      },
    );

    // Create the map and add linkedSocials
    Map<String, dynamic> userMap = completeUser.toMap();
    userMap['socialMedia'] = _socialMedia;
    
    print('📊 User data prepared. Map keys: ${userMap.keys.toList()}');
    
    // Update the user profile with complete data
    await authService.updateUserProfile(userMap);
    print('✅ Complete user profile created');

    setState(() {
      _isCreatingProfile = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(FontAwesomeIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Profile created successfully! \nWelcome to Connecta!'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );

    // Wait a moment before navigating
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to main screen
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
        (route) => false,
      );
    }

  } catch (e) {
    setState(() {
      _isCreatingProfile = false;
    });

    print('💥 Error creating profile: $e');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Error creating profile: ${e.toString()}'),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose all text controllers
    for (var controller in _linkControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
