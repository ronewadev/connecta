import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connecta/screens/auth/onboarding/interests_deal_breakers_screen.dart';

class UploadImagesScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;
  final int age;
  final String gender;
  final String mobile;
  final String nationality;
  final String bio;
  final File? profileImage;

  const UploadImagesScreen({
    super.key,
    required this.email,
    required this.password,
    required this.username,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.nationality,
    required this.bio,
    this.profileImage,
  });

  @override
  State<UploadImagesScreen> createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _images = List.filled(5, null);
  bool _isUploading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
                              'Add Your Photos',
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
                            'Upload up to 5 photos to showcase yourself',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Info Card (Photo Tips at the top)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.all(24),
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
                                child: Column(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.lightbulb,
                                      color: Colors.white.withOpacity(0.9),
                                      size: 32,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Photo Tips',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.95),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      '• Show your face clearly in the first photo\n'
                                      '• Include variety: close-ups and full body\n'
                                      '• Use natural lighting when possible\n'
                                      '• Show your interests and hobbies\n'
                                      '• Smile and be authentic!',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 16,
                                        height: 1.6,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Photos Grid
                          _buildPhotosGrid(),
                          const SizedBox(height: 32),
                          
                          // Continue Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: (_images[0] != null && !_isUploading)
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
                              boxShadow: (_images[0] != null && !_isUploading)
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
                              onPressed: (_images[0] != null && !_isUploading) ? _continueToNext : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: _isUploading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: (_images[0] != null && !_isUploading)
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.5),
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
                'Step 2 of 6',
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
            value: 0.33, // 2/6
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildImageContainer(index);
      },
    );
  }

  Widget _buildImageContainer(int index) {
    final hasImage = _images[index] != null;
    final isMainPhoto = index == 0;
    
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: hasImage
                    ? [
                        const Color(0xFFEC4899).withOpacity(0.3),
                        const Color(0xFFBE185D).withOpacity(0.2),
                      ]
                    : [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.15),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasImage
                    ? const Color(0xFFEC4899).withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
                width: hasImage ? 2 : 1.5,
              ),
            ),
            child: hasImage
                ? Stack(
                    children: [
                      // Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            File(_images[index]!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      // Main Photo Badge
                      if (isMainPhoto)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFEC4899),
                                  const Color(0xFFBE185D),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Main',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      
                      // Remove Button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.xmark,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white.withOpacity(0.8),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isMainPhoto ? 'Main Photo' : 'Add Photo',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isMainPhoto)
                        Text(
                          '(Required)',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress to retain quality while reducing size
        maxWidth: 1200,
        maxHeight: 1600,
      );
      
      if (image != null) {
        setState(() {
          _images[index] = image;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Photo added successfully!'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  Future<void> _continueToNext() async {
    // Check if main photo is required
    if (_images[0] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least a main photo'),
          backgroundColor: const Color(0xFFEC4899),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulate image processing/upload
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading = false;
    });

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => InterestsDealbrakersScreen(
          email: widget.email,
          password: widget.password,
          username: widget.username,
          age: widget.age,
          gender: widget.gender,
          mobile: widget.mobile,
          nationality: widget.nationality,
          images: _images.where((img) => img != null).map((img) => img!.path).toList(),
          bio: widget.bio,
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
