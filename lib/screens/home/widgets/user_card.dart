import 'package:flutter/material.dart';
import 'package:connecta/screens/plans/widgets/premium_badge.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/user_model.dart';

class UserCard extends StatefulWidget {
  final User user;
  final Function()? onMessageTap;

  const UserCard({super.key, required this.user, this.onMessageTap});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  int _currentImageIndex = 0;
  
  List<String> get _images {
    // Use dummy images for all users
    final dummyImages = [
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&h=1000',
    ];
    
    // Return a random subset of 3-5 images for each user
    final userId = widget.user.id.hashCode;
    final random = userId % 100;
    final numImages = 3 + (random % 3); // 3-5 images
    
    return dummyImages.take(numImages).toList();
  }

  void _nextImage() {
    if (_images.length > 1) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    }
  }

  void _previousImage() {
    if (_images.length > 1) {
      setState(() {
        _currentImageIndex = (_currentImageIndex - 1 + _images.length) % _images.length;
      });
    }
  }

  Widget _buildActivityStatus() {
    final now = DateTime.now();
    final difference = now.difference(widget.user.lastActive);
    
    Color statusColor;
    String statusText;
    
    if (widget.user.isOnline) {
      statusColor = Colors.green;
      statusText = 'Online';
    } else if (difference.inHours < 24) {
      statusColor = Colors.orange;
      statusText = 'Recently active';
    } else {
      statusColor = Colors.red;
      statusText = 'Offline';
    }
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.6),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          statusText,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Stack(
        children: [
          // Main image background
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (details) {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final localPosition = renderBox.globalToLocal(details.globalPosition);
                final cardWidth = renderBox.size.width;
                final tapPositionRatio = localPosition.dx / cardWidth;
                
                // 30% left side for previous image, 70% right side for next image
                if (tapPositionRatio < 0.3) {
                  _previousImage();
                } else if (tapPositionRatio > 0.3) {
                  _nextImage();
                }
              },
              child: Image.network(
                _images[_currentImageIndex],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.person, size: 64, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Image indicators
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
                        '${widget.user.name}, ${widget.user.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.user.isVerified)
                        const Icon(Icons.verified, color: Colors.lightBlue),
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
                      const Icon(Icons.location_on, 
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
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '2.5 km away',
                    style: const TextStyle(
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
            child: Column(
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
                    const Color(0xFF029C42)), // YouTube red
              ],
            ),
          ),
          // Message button
          Positioned(
            top: 16,
            left: 16,
            child: InkWell(
              onTap: widget.onMessageTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.message,
                  color: Colors.pink,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialIconButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FaIcon(
        icon,
        color: color,
        size: 18,
      ),
    );
  }
}