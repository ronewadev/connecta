import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../models/user_model.dart';

class UserDetailModal extends StatelessWidget {
  final User user;

  final Widget Function(User) profileImagesCarouselBuilder;
  final Widget Function(String, ThemeData) interestChipBuilder;

  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onBoost;

  const UserDetailModal({
    Key? key,
    required this.user,
    required this.profileImagesCarouselBuilder,
    required this.interestChipBuilder,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onBoost,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildActionButtons(theme, context),
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

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Expanded(
            child: _buildModalActionButton(
              icon: FontAwesomeIcons.xmark,
              color: theme.colorScheme.error,
              onPressed: () {
                Navigator.pop(context);
                onDislike();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModalActionButton(
              icon: FontAwesomeIcons.star,
              color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
                onSuperLike();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModalActionButton(
              icon: FontAwesomeIcons.heart,
              color: Colors.green,
              onPressed: () {
                Navigator.pop(context);
                onLike();
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModalActionButton(
              icon: FontAwesomeIcons.bolt,
              color: Colors.purple,
              onPressed: () {
                Navigator.pop(context);
                onBoost();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.15),
        foregroundColor: color,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(14),
      ),
      child: FaIcon(icon, size: 20),
    );
  }
}
