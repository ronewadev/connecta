import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart';
import 'package:connecta/screens/plans/subscription_screen.dart';

class LikesScreen extends StatefulWidget {
  final List<String> likedByUserIds;
  final List<String> superLikedByUserIds;
  final List<String> lovedByUserIds;

  const LikesScreen({
    Key? key,
    required this.likedByUserIds,
    required this.superLikedByUserIds,
    required this.lovedByUserIds,
  }) : super(key: key);

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  List<User> allUsers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchUsers();
  }

  void _setupAnimations() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _fetchUsers() async {
    try {
      // Combine all unique user IDs from all three lists
      final allUserIds = [
        ...widget.likedByUserIds,
        ...widget.superLikedByUserIds,
        ...widget.lovedByUserIds,
      ].toSet().toList();

      if (allUserIds.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch all users in a single query
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: allUserIds)
          .get();

      // Map documents to User objects
      final users = usersSnapshot.docs.map((doc) {
        return User.fromMap(doc.data(), doc.id);
      }).toList();

      setState(() {
        allUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load likes. Please try again.';
      });
      debugPrint('Error fetching users: $e');
    }
  }

  bool _isSuperLiked(String userId) {
    return widget.superLikedByUserIds.contains(userId);
  }

  bool _isLoved(String userId) {
    return widget.lovedByUserIds.contains(userId);
  }

  bool _isLiked(String userId) {
    return widget.likedByUserIds.contains(userId) &&
        !_isSuperLiked(userId) &&
        !_isLoved(userId);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchUsers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Counts for each type
    final likedCount = widget.likedByUserIds.length;
    final superLikedCount = widget.superLikedByUserIds.length;
    final lovedCount = widget.lovedByUserIds.length;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Likes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.star,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    // Loves
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.heart,
                        size: 50,
                        color: Colors.pink,
                      ),
                    ),
                    // Super likes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const FaIcon(
                        FontAwesomeIcons.bolt,
                        size: 35,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Likes You',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$likedCount people liked you\n'
                      '$superLikedCount people super liked you\n'
                      '$lovedCount people loved you',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
                      const FaIcon(
                        FontAwesomeIcons.crown,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Upgrade to see who likes you',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

        // Display users grid if we have users
        if (allUsers.isNotEmpty)
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
                  final user = allUsers[index];
                  return _buildLikeCard(context, user, index);
                },
                childCount: allUsers.length,
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No likes yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keep using the app to get more likes!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

        // Upgrade section
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
                const FaIcon(
                  FontAwesomeIcons.crown,
                  size: 48,
                  color: Colors.amber,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unlock Likes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'See who likes you and get unlimited likes',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  gradientColors: const [Colors.amber, Colors.orange],
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionScreen(),
                      ),
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
    final bool isSuperLike = _isSuperLiked(user.id);
    final bool isLove = _isLoved(user.id);
    final bool isLike = _isLiked(user.id);

    // Set colors based on like type
    final Color borderColor = isSuperLike
        ? Colors.purple
        : isLove
        ? Colors.pink
        : Colors.blue;
    final Color indicatorColor = borderColor;
    final IconData indicatorIcon = isSuperLike
        ? FontAwesomeIcons.bolt
        : isLove
        ? FontAwesomeIcons.heart
        : FontAwesomeIcons.star;

    // Blur logic - only show first 2 of each type clearly
    final int userIndex = isSuperLike
        ? widget.superLikedByUserIds.indexOf(user.id)
        : isLove
        ? widget.lovedByUserIds.indexOf(user.id)
        : widget.likedByUserIds.indexOf(user.id);
    final bool isBlurred = userIndex >= 2;

    return GestureDetector(
      onTap: () => _handleCardTap(context, user, isBlurred),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 3),
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
                user.profileImageUrl ?? 'https://i.pravatar.cc/300?u=${user.id}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                              const FaIcon(
                                FontAwesomeIcons.crown,
                                color: Colors.amber,
                                size: 24,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Premium',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        user.username ?? 'Unknown',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${user.age ?? ''} • ${user.location ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    color: indicatorColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: indicatorColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    indicatorIcon,
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
      _showPremiumDialog(context);
    } else {
      _showMatchDialog(context, user);
    }
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.amber,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Premium Required',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upgrade to Premium to see who likes you and unlock unlimited features!',
              style: Theme.of(context).textTheme.bodyMedium,
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
          TextButton(
            child: const Text('Maybe Later'),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubscriptionScreen(),
                ),
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
                user.profileImageUrl ?? 'https://i.pravatar.cc/300?u=${user.id}',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 120,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.user,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.username ?? 'Unknown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${user.age ?? ''} • ${user.location ?? ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    child: const Text('Pass'),
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
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.heart,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'It\'s a Match!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You and ${user.username ?? 'Unknown'} liked each other',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  const SnackBar(content: Text(AppText.comingSoon)),
                );
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              child: const Text('Keep Swiping'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}