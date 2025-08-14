import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:connecta/screens/plans/widgets/premium_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/user_model.dart';

class UserCard extends StatefulWidget {
  final UserModelInfo user;
  final String? currentUserId;
  final Function()? onMessageTap;

  const UserCard({
    super.key, 
    required this.user, 
    this.currentUserId,
    this.onMessageTap,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> with TickerProviderStateMixin {
  int _currentImageIndex = 0;
  late AnimationController _tapAnimationController; // Remove nullable and make late
  late Animation<double> _tapAnimation; // Remove nullable and make late
  bool _showLeftTapIndicator = false;
  bool _showRightTapIndicator = false;
  
  List<String> get _images {
    // Only use actual profile images from the user model
    final images = <String>[];
    if (widget.user.profileImageUrl != null && widget.user.profileImageUrl!.isNotEmpty) {
      images.add(widget.user.profileImageUrl!);
    }
    if (widget.user.profileImages.isNotEmpty) {
      images.addAll(widget.user.profileImages.where((img) => img.isNotEmpty && img != widget.user.profileImageUrl));
    }
    return images;
  }

  @override
  void initState() {
    super.initState();
    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _tapAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _tapAnimationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    super.dispose();
  }

  void _nextImage() {
    if (_images.length > 1) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
        _showRightTapIndicator = true;
      });
      print('📸 Next image: ${_currentImageIndex + 1} of ${_images.length}');
      
      // Hide the tap indicator after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showRightTapIndicator = false;
          });
        }
      });
    }
  }

  void _previousImage() {
    if (_images.length > 1) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentImageIndex = (_currentImageIndex - 1 + _images.length) % _images.length;
        _showLeftTapIndicator = true;
      });
      print('📸 Previous image: ${_currentImageIndex + 1} of ${_images.length}');
      
      // Hide the tap indicator after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showLeftTapIndicator = false;
          });
        }
      });
    }
  }

  void _onTapDown(TapDownDetails details, double screenWidth) {
    _tapAnimationController.forward(); // Remove the null check
  }

  void _onTapUp(TapUpDetails details, double screenWidth) {
    _tapAnimationController.reverse(); // Remove the null check
    
    final tapX = details.localPosition.dx;
    final cardWidth = screenWidth - 32; // Account for padding
    
    print('👆 Tap at X: $tapX, Card width: $cardWidth');
    
    if (tapX < cardWidth * 0.4) {
      // Left 40% of card - previous image
      print('👈 Tapping left side - previous image');
      _previousImage();
    } else if (tapX > cardWidth * 0.6) {
      // Right 40% of card - next image
      print('👉 Tapping right side - next image');
      _nextImage();
    }
    // Middle 20% does nothing (reserved for other interactions)
  }

  Widget _buildActivityStatus() {
    final now = DateTime.now();
    final difference = now.difference(widget.user.lastActive);
    
    Color statusColor;
    String statusText;
    
    if (widget.user.isOnline) {
      statusColor = Colors.green;
      statusText = 'Online';
    } else if (difference.inMinutes < 60) {
      statusColor = Colors.orange;
      statusText = '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      statusColor = Colors.orange;
      statusText = '${difference.inHours}h ago';
    } else {
      statusColor = Colors.grey;
      statusText = '${difference.inDays}d ago';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionIndicators() {
    if (widget.currentUserId == null) return const SizedBox.shrink();

    final bool isLikedByMe = widget.user.likesMe.contains(widget.currentUserId);
    final bool isSuperLikedByMe = widget.user.superLikesMe.contains(widget.currentUserId);
    final bool isLovedByMe = widget.user.lovesMe.contains(widget.currentUserId);

    if (!isLikedByMe && !isSuperLikedByMe && !isLovedByMe) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLovedByMe) ...[
              const FaIcon(FontAwesomeIcons.heart, color: Colors.pink, size: 16),
              const SizedBox(width: 4),
              const Text('Loves You', style: TextStyle(color: Colors.white, fontSize: 12)),
            ] else if (isSuperLikedByMe) ...[
              const FaIcon(FontAwesomeIcons.star, color: Colors.blue, size: 16),
              const SizedBox(width: 4),
              const Text('Super Likes You', style: TextStyle(color: Colors.white, fontSize: 12)),
            ] else if (isLikedByMe) ...[
              const FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.green, size: 16),
              const SizedBox(width: 4),
              const Text('Likes You', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTapIndicators() {
    if (_images.length <= 1) return const SizedBox.shrink();

    return Stack(
      children: [
        // Left tap indicator
        if (_showLeftTapIndicator)
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        
        // Right tap indicator
        if (_showRightTapIndicator)
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageNavigationZones() {
    if (_images.length <= 1) return const SizedBox.shrink();

    return Row(
      children: [
        // Left navigation zone (40% of card)
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.transparent,
            child: _currentImageIndex > 0
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        // Middle zone (20% - no navigation)
        Expanded(
          flex: 2,
          child: Container(color: Colors.transparent),
        ),
        // Right navigation zone (40% of card)
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.transparent,
            child: _currentImageIndex < _images.length - 1
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageUrl = _images.isNotEmpty ? _images.first : null;

    return ScaleTransition(
      scale: _tapAnimation,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Always cover the card
              imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: FaIcon(FontAwesomeIcons.user, size: 50, color: Colors.grey),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: FaIcon(FontAwesomeIcons.user, size: 50, color: Colors.grey),
                      ),
                    ),
              

              // Navigation zones overlay (only visible when there are multiple images)
              if (_images.length > 1)
                Positioned.fill(
                  child: _buildImageNavigationZones(),
                ),

              // Tap indicators
              Positioned.fill(
                child: _buildTapIndicators(),
              ),
            
              // Image indicators (dots)
              if (_images.length > 1)
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: List.generate(_images.length, (index) {
                      return Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.only(right: index < _images.length - 1 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: index == _currentImageIndex 
                                ? Colors.white 
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              // Interaction indicators
              _buildInteractionIndicators(),

              // Gradient overlay for text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // User info at the bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name, age and verification
                      Row(
                        children: [
                          Text(
                            '${widget.user.username}, ${widget.user.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.user.isVerified)
                            const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.lightBlue),
                          const SizedBox(width: 8),
                          if (widget.user.subscriptionType != 'basic')
                            PremiumBadge(type: widget.user.subscriptionType),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Activity status
                      _buildActivityStatus(),
                      const SizedBox(height: 4),
                      // Location
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.locationDot, 
                            color: Colors.white70, 
                            size: 16
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.user.location,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.user.nationality,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      if (widget.user.bio != null && widget.user.bio!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.user.bio!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      // Interests
                      SizedBox(
                        height: 30,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.user.interests.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.user.interests[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Location indicator
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(FontAwesomeIcons.locationDot, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        '2.5 km away',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Social media icons
              Positioned(
                top: 70,
                right: 16,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildSocialIconButton(FontAwesomeIcons.facebook,
                              const Color(0xFF1877F2)), // Facebook blue
                          const SizedBox(height: 12),
                          _buildSocialIconButton(FontAwesomeIcons.instagram,
                              const Color(0xFFE4405F)), // Instagram pink
                          const SizedBox(height: 12),
                          _buildSocialIconButton(FontAwesomeIcons.xTwitter,
                              const Color(0xFF000000)), // Twitter blue
                          const SizedBox(height: 12),
                          _buildSocialIconButton(FontAwesomeIcons.tiktok,
                              const Color(0xFF000000)), // TikTok black
                          const SizedBox(height: 12),
                          _buildSocialIconButton(FontAwesomeIcons.whatsapp,
                              const Color(0xFF029C42)), // WhatsApp green
                        ],
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: widget.onMessageTap,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: FaIcon(FontAwesomeIcons.commentDots,
                                color: Colors.black,
                                size: 18
                            ),
                          ),
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
    );
  }

  Widget _buildSocialIconButton(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: FaIcon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}