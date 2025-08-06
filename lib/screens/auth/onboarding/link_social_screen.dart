import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/main_screen.dart';

class LinkSocialScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final int avatarIndex;
  final List<String> images;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final List<String> lookingFor;
  // New preference parameters
  final List<int> ageRange;
  final int maxDistance;
  final List<String> interestedIn;
  final List<String> relationshipType;
  final List<String> education;
  final List<String> lifestyle;
  final bool showOnline;
  final bool verifiedOnly;
  final bool photoRequired;

  const LinkSocialScreen({
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
    required this.interests,
    required this.hobbies,
    required this.dealBreakers,
    required this.lookingFor,
    required this.ageRange,
    required this.maxDistance,
    required this.interestedIn,
    required this.relationshipType,
    required this.education,
    required this.lifestyle,
    required this.showOnline,
    required this.verifiedOnly,
    required this.photoRequired,
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

  bool _allowDirectContact = false;
  bool _isCreatingProfile = false;

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
    setState(() {
      _linkedPlatforms[platform] = !_linkedPlatforms[platform]!;
    });
    
    // Show appropriate message
    final message = _linkedPlatforms[platform]!
        ? '$platform connected successfully!'
        : '$platform disconnected';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _linkedPlatforms[platform]!
            ? const Color(0xFF4CAF50)
            : const Color(0xFF6B46C1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showDirectContactInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF6B46C1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Direct Contact',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'When enabled, other users will be able to contact you directly through your linked social platforms. This adds more ways to connect but also shares your social profiles with matches.',
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeProfile() async {
    setState(() {
      _isCreatingProfile = true;
    });

    // Simulate profile creation
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isCreatingProfile = false;
    });

    // Show success message
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
      ),
    );

    // Navigate to main screen
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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
