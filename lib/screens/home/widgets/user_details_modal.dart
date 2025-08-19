import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../../../models/user_model.dart';

class UserDetailModal extends StatelessWidget {
  final UserModelInfo user;
  final Widget Function(UserModelInfo) profileImagesCarouselBuilder;
  final Widget Function(String, ThemeData) interestChipBuilder;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onBoost; // This will be the love action
  final VoidCallback? onUndo; // Add undo action

  const UserDetailModal({
    Key? key,
    required this.user,
    required this.profileImagesCarouselBuilder,
    required this.interestChipBuilder,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onBoost,
    this.onUndo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            _buildHandleBar(theme),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 120,
                        height: 5, 
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withAlpha(70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    profileImagesCarouselBuilder(user),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(theme),
                          const SizedBox(height: 8),
                          _buildLocation(theme),
                          const SizedBox(height: 20),
                          _buildSectionTitle('About Me', theme),
                          const SizedBox(height: 8),
                          Text(
                            user.bio ?? '',
                            style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Socials Linked', theme),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: user.socialMediaLinks.take(3).map((link) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: _getSocialMediaIcon(link),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Interests', theme),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: user.interests
                                ?.map((interest) =>
                                interestChipBuilder(interest, theme))
                                .toList() ??
                                [],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Hobbies', theme),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: user.hobbies
                                ?.map((hobby) =>
                                interestChipBuilder(hobby, theme))
                                .toList() ??
                                [],
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Deal breakers', theme),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: user.dealBreakers
                                ?.map((dealBreaker) =>
                                interestChipBuilder(dealBreaker, theme))
                                .toList() ??
                                [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildEnhancedBottomActions(theme),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Text(
          '${user.username}, ${user.age}',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (user.isVerified)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(
              Icons.verified,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
      ],
    );
  }

  Widget _buildLocation(ThemeData theme) {
    return Row(
      children: [
        Icon(
          FontAwesomeIcons.locationDot,
          size: 14,
          color: theme.textTheme.bodySmall?.color,
        ),
        const SizedBox(width: 8),
        Text(
          user.location ?? '',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedBottomActions(ThemeData theme) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        height: 75,
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
                    size: 28,
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
                    size: 28,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      onLike();
                    },
                  ),
                  _divider(theme),

                  // Like Button
                  _buildEnhancedActionButton(
                    icon: FontAwesomeIcons.heart,
                    color: Colors.green,
                    size: 28,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onBoost();
                    },
                  ),
                  _divider(theme),

                  // Love Button
                  _buildEnhancedActionButton(
                    icon: FontAwesomeIcons.bolt,
                    color: Colors.purple,
                    size: 28,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      onSuperLike();
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

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

  Widget _divider(ThemeData theme) => Container(
    width: 1,
    height: 30,
    color: theme.colorScheme.outline.withOpacity(0.2),
  );

  Widget _getSocialMediaIcon(String link) {
    final platform = link.split(':')[0].toLowerCase();
    IconData icon;
    Color color;

    switch (platform) {
      case 'instagram':
        icon = FontAwesomeIcons.instagram;
        color = const Color(0xFFE4405F);
        break;
      case 'facebook':
        icon = FontAwesomeIcons.facebook;
        color = const Color(0xFF1877F2);
        break;
      case 'whatsapp':
        icon = FontAwesomeIcons.whatsapp;
        color = const Color(0xFF25D366);
        break;
      case 'tiktok':
        icon = FontAwesomeIcons.tiktok;
        color = Colors.black;
        break;
      case 'twitter':
        icon = FontAwesomeIcons.twitter;
        color = const Color(0xFF1DA1F2);
        break;
      default:
        icon = FontAwesomeIcons.link;
        color = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(
            icon,
            size: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
