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

            _buildEnhancedActionButtons(theme, context),
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

  Widget _buildEnhancedActionButtons(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Dislike Button
              _buildActionButton(
                icon: FontAwesomeIcons.xmark,
                color: Colors.red,
                size: 50,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  onDislike();
                },
              ),
              
              // Super Like Button (bigger)
              _buildActionButton(
                icon: FontAwesomeIcons.star,
                color: Colors.blue,
                size: 65,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  onSuperLike();
                },
              ),
              
              // Like Button
              _buildActionButton(
                icon: FontAwesomeIcons.heart,
                color: Colors.green,
                size: 50,
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  onLike();
                },
              ),
              
              // Love Button (boost)
              _buildActionButton(
                icon: FontAwesomeIcons.heart,
                color: Colors.pink,
                size: 50,
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pop(context);
                  onBoost();
                },
              ),
            ],
          ),
          
          // Secondary actions row
          if (onUndo != null) ...[
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Undo Button
                _buildActionButton(
                  icon: FontAwesomeIcons.rotateLeft,
                  color: Colors.amber,
                  size: 40,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    onUndo!();
                  },
                ),
              ],
            ),
          ],
        ],
      ),
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
}
