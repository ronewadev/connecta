import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  
  // Demo data - users who liked you
  final List<User> _likedByUsers = [
    User(
      id: '1',
      name: 'Emma Watson',
      age: 25,
      profileImageUrl: 'https://i.pravatar.cc/300?img=1',
      bio: 'Love traveling and photography',
      location: 'New York',
      interests: ['Photography', 'Travel', 'Books'], username: '', email: '', gender: '', nationality: '',
    ),
    User(
      id: '2',
      name: 'Sophie Turner',
      age: 27,
      profileImageUrl: 'https://i.pravatar.cc/300?img=2',
      bio: 'Artist and coffee lover',
      location: 'Los Angeles',
      interests: ['Art', 'Coffee', 'Music'], username: '', email: '', gender: '', nationality: '',
    ),
    User(
      id: '3',
      name: 'Zendaya',
      age: 24,
      profileImageUrl: 'https://i.pravatar.cc/300?img=3',
      bio: 'Dancer and actress',
      location: 'Hollywood',
      interests: ['Dancing', 'Acting', 'Fashion'], username: '', email: '', gender: '', nationality: '',
    ),
    User(
      id: '4',
      name: 'Taylor Swift',
      age: 28,
      profileImageUrl: 'https://i.pravatar.cc/300?img=4',
      bio: 'Music is my passion',
      location: 'Nashville',
      interests: ['Music', 'Writing', 'Cats'], username: '', email: '', gender: '', nationality: '',
    ),
    User(
      id: '5',
      name: 'Ariana Grande',
      age: 26,
      profileImageUrl: 'https://i.pravatar.cc/300?img=5',
      bio: 'Singer and animal lover',
      location: 'Miami',
      interests: ['Singing', 'Animals', 'Yoga'], username: '', email: '', gender: '', nationality: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomScrollView(
      slivers: [
        // Header Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.heart,
                    size: 40,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Likes You',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_likedByUsers.length} people liked you',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.crown,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Upgrade to see who likes you',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Likes Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final user = _likedByUsers[index];
                return _buildLikeCard(context, user, index);
              },
              childCount: _likedByUsers.length,
            ),
          ),
        ),

        // Bottom Upgrade Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withOpacity(0.1),
                  Colors.orange.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.crown,
                  size: 48,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unlock Likes',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'See who likes you and get unlimited likes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.amber.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Get Premium',
                  backgroundColor: Colors.amber,
                  textColor: Colors.white,
                  width: double.infinity,
                  icon: FontAwesomeIcons.crown,
                  isGradient: true,
                  gradientColors: [Colors.amber, Colors.orange],
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.comingSoon)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildLikeCard(BuildContext context, User user, int index) {
    final theme = Theme.of(context);
    final isBlurred = index >= 2; // Show first 2 clearly, blur the rest
    
    return GestureDetector(
      onTap: () => _handleCardTap(context, user, isBlurred),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Profile Image
              Image.network(
                user.profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),

              // Blur overlay for premium cards
              if (isBlurred)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Stack(
                    children: [
                      // Shimmer effect
                      AnimatedBuilder(
                        animation: _shimmerAnimation,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.4),
                                  Colors.transparent,
                                ],
                                stops: [
                                  (_shimmerAnimation.value - 1).clamp(0.0, 1.0),
                                  _shimmerAnimation.value.clamp(0.0, 1.0),
                                  (_shimmerAnimation.value + 1).clamp(0.0, 1.0),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Blur content
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.crown,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Premium',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),

              // User info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${user.age} • ${user.location}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Like indicator
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.heart,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCardTap(BuildContext context, User user, bool isBlurred) {
    if (isBlurred) {
      // Show premium upgrade dialog
      _showPremiumDialog(context);
    } else {
      // Show user profile or match action
      _showMatchDialog(context, user);
    }
  }

  void _showPremiumDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.amber,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Premium Required',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upgrade to Premium to see who likes you and unlock unlimited features!',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFeatureRow(FontAwesomeIcons.eye, 'See who likes you'),
                  _buildFeatureRow(FontAwesomeIcons.infinity, 'Unlimited likes'),
                  _buildFeatureRow(FontAwesomeIcons.bolt, 'Super likes'),
                  _buildFeatureRow(FontAwesomeIcons.locationDot, 'Passport feature'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SecondaryButton(
            text: 'Maybe Later',
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: 'Get Premium',
            backgroundColor: Colors.amber,
            textColor: Colors.white,
            icon: FontAwesomeIcons.crown,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.comingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 16,
            color: Colors.amber,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.amber.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMatchDialog(BuildContext context, User user) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                user.profileImageUrl!,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${user.age} • ${user.location}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Pass',
                    icon: FontAwesomeIcons.xmark,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Like Back',
                    backgroundColor: Colors.pink,
                    textColor: Colors.white,
                    icon: FontAwesomeIcons.heart,
                    onPressed: () {
                      Navigator.pop(context);
                      _showMatchSuccess(context, user);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMatchSuccess(BuildContext context, User user) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.pink.shade50,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'It\'s a Match!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You and ${user.name} liked each other',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.pink.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Start Chatting',
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              width: double.infinity,
              icon: FontAwesomeIcons.commentDots,
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            const SizedBox(height: 8),
            SecondaryButton(
              text: 'Keep Swiping',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
