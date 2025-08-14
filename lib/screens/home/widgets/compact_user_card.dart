import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/user_model.dart';

class CompactUserCard extends StatelessWidget {
  final UserModelInfo user;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onLove; // Add love action
  final VoidCallback onUndo; // Add undo action
  final VoidCallback onMoreOptions;

  const CompactUserCard({
    Key? key,
    required this.user,
    required this.index,
    required this.onTap,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onLove, // Add love parameter
    required this.onUndo, // Add undo parameter
    required this.onMoreOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  user.profileImageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.primary.withOpacity(0.8),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),

              // Top indicators
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    if (user.socialMediaLinks.isNotEmpty)
                      _buildSocialMediaIcons(theme),
                    const Spacer(),
                    if (user.isOnline) _buildOnlineIndicator(theme),
                  ],
                ),
              ),

              if (user.isVerified)
                Positioned(
                  top: 12,
                  right: user.isOnline ? 32 : 12,
                  child: _buildVerificationBadge(theme),
                ),

              // User details
              Positioned(
                bottom: 75, // Increased to accommodate new buttons
                left: 0,
                right: 0,
                child: _buildUserInfo(theme),
              ),

              // Enhanced bottom action bar with all controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildEnhancedBottomActions(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaIcons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: user.socialMediaLinks.take(3).map((link) {
          return Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _getSocialMediaIcon(link),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOnlineIndicator(ThemeData theme) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildVerificationBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.surface,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.verified,
        color: theme.colorScheme.surface,
        size: 12,
      ),
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${user.username}, ${user.age}',
            style: TextStyle(
              color: theme.colorScheme.surface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: theme.colorScheme.surface.withOpacity(0.8),
                size: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  user.location,
                  style: TextStyle(
                    color: theme.colorScheme.surface.withOpacity(0.8),
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 2,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (user.interests.isNotEmpty)
            SizedBox(
              height: 20,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: user.interests.length.clamp(0, 2),
                itemBuilder: (context, i) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.9),
                          theme.colorScheme.secondary.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: theme.colorScheme.surface.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      user.interests[i],
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBottomActions(ThemeData theme) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 75, // Increased height for two rows
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface.withOpacity(0.95),
                theme.colorScheme.surface.withOpacity(0.9),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              // Top row - main actions
              Expanded(
                child: Row(
                  children: [
                    // Dislike Button
                    _buildEnhancedActionButton(
                      icon: FontAwesomeIcons.xmark,
                      color: Colors.red,
                      size: 16,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onDislike();
                      },
                    ),
                    _divider(theme),
                    
                    // Super Like Button
                    _buildEnhancedActionButton(
                      icon: FontAwesomeIcons.star,
                      color: Colors.blue,
                      size: 18,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onSuperLike();
                      },
                    ),
                    _divider(theme),
                    
                    // Like Button
                    _buildEnhancedActionButton(
                      icon: FontAwesomeIcons.heart,
                      color: Colors.green,
                      size: 16,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onLike();
                      },
                    ),
                    _divider(theme),
                    
                    // Love Button
                    _buildEnhancedActionButton(
                      icon: FontAwesomeIcons.heart,
                      color: Colors.pink,
                      size: 16,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        onLove();
                      },
                    ),
                  ],
                ),
              ),
              // Bottom row - secondary actions
              Container(
                height: 35,
                child: Row(
                  children: [
                    // Undo Button
                    _buildSmallActionButton(
                      icon: FontAwesomeIcons.rotateLeft,
                      color: Colors.amber,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onUndo();
                      },
                    ),
                    _divider(theme),
                    
                    // More Options Button
                    _buildSmallActionButton(
                      icon: FontAwesomeIcons.ellipsis,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        onMoreOptions();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(ThemeData theme) => Container(
    width: 1,
    height: 30,
    color: theme.colorScheme.outline.withOpacity(0.2),
  );

  Widget _buildEnhancedActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    icon, 
                    color: color, 
                    size: size,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            child: Center(
              child: FaIcon(
                icon, 
                color: color, 
                size: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getSocialMediaIcon(String link) {
    return const Icon(Icons.link, size: 14);
  }
}
