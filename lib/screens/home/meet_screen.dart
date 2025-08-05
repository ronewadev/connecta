import 'package:connecta/models/user_model.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> with TickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<User> _users = [];
  bool _showLikeFeedback = false;
  bool _showDislikeFeedback = false;
  bool _showSuperLikeFeedback = false;
  
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackOpacity;

  @override
  void initState() {
    super.initState();
    _loadDummyUsers();
    _setupAnimations();
  }

  void _setupAnimations() {
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _feedbackScale = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.elasticOut,
    ));
    
    _feedbackOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: const Interval(0.6, 1.0),
    ));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _loadDummyUsers() {
    setState(() {
      _users.addAll([
        User(
          id: '1',
          username: 'Jessica',
          name: 'Jessica',
          email: 'jessica@email.com',
          age: 24,
          gender: 'Female',
          nationality: 'USA',
          location: 'New York',
          profileImageUrl: 'https://i.pravatar.cc/400?img=32',
          bio: 'Adventure seeker and coffee lover ☕ Love exploring new places and meeting interesting people! 🌍✈️',
          interests: ['Hiking', 'Photography', 'Travel', 'Coffee', 'Art'],
        ),
        User(
          id: '2',
          username: 'Alex',
          name: 'Alex',
          email: 'alex@email.com',
          age: 28,
          gender: 'Male',
          nationality: 'Canada',
          location: 'Toronto',
          profileImageUrl: 'https://i.pravatar.cc/400?img=18',
          bio: 'Musician by night, developer by day 🎸💻 Looking for someone to share adventures with!',
          interests: ['Music', 'Coding', 'Gaming', 'Movies', 'Food'],
        ),
        User(
          id: '3',
          username: 'Sofia',
          name: 'Sofia',
          email: 'sofia@email.com',
          age: 26,
          gender: 'Female',
          nationality: 'Spain',
          location: 'Barcelona',
          profileImageUrl: 'https://i.pravatar.cc/400?img=25',
          bio: 'Yoga instructor and mindfulness coach 🧘‍♀️ Spreading positive vibes everywhere I go ✨',
          interests: ['Yoga', 'Meditation', 'Wellness', 'Nature', 'Books'],
        ),
        User(
          id: '4',
          username: 'David',
          name: 'David',
          email: 'david@email.com',
          age: 30,
          gender: 'Male',
          nationality: 'Australia',
          location: 'Sydney',
          profileImageUrl: 'https://i.pravatar.cc/400?img=12',
          bio: 'Fitness enthusiast and outdoor lover 🏋️‍♂️🏖️ Life is better with good company!',
          interests: ['Fitness', 'Surfing', 'Cooking', 'Travel', 'Dogs'],
        ),
        User(
          id: '5',
          username: 'Emma',
          name: 'Emma',
          email: 'emma@email.com',
          age: 25,
          gender: 'Female',
          nationality: 'UK',
          location: 'London',
          profileImageUrl: 'https://i.pravatar.cc/400?img=45',
          bio: 'Artist and creative soul 🎨 Always looking for inspiration in everyday moments',
          interests: ['Art', 'Painting', 'Museums', 'Wine', 'Culture'],
        ),
      ]);
    });
  }

  void _handleLike() {
    if (_users.isEmpty) return;
    HapticFeedback.lightImpact();
    _swiperController.swipe(CardSwiperDirection.right);
  }

  void _handleDislike() {
    if (_users.isEmpty) return;
    HapticFeedback.lightImpact();
    _swiperController.swipe(CardSwiperDirection.left);
  }
  
  void _handleSuperLike() {
    if (_users.isEmpty) return;
    HapticFeedback.mediumImpact();
    _swiperController.swipe(CardSwiperDirection.top);
  }
  
  void _handleUndo() {
    HapticFeedback.lightImpact();
    try {
      _swiperController.undo();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(FontAwesomeIcons.rotateLeft, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(AppText.returnUndo),
            ],
          ),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more actions to undo')),
      );
    }
  }
  
  void _showFeedback(String text, Color color) {
    setState(() {
      _showLikeFeedback = text == 'LIKE';
      _showDislikeFeedback = text == 'NOPE';
      _showSuperLikeFeedback = text == 'SUPER LIKE';
    });
    
    _feedbackController.forward().then((_) {
      _feedbackController.reset();
      setState(() {
        _showLikeFeedback = false;
        _showDislikeFeedback = false;
        _showSuperLikeFeedback = false;
      });
    });
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    HapticFeedback.selectionClick();
    
    // Handle different swipe directions
    switch (direction) {
      case CardSwiperDirection.left:
        _showFeedback('NOPE', Colors.red);
        _onUserDisliked(previousIndex);
        break;
      case CardSwiperDirection.right:
        _showFeedback('LIKE', Colors.green);
        _onUserLiked(previousIndex);
        break;
      case CardSwiperDirection.top:
        _showFeedback('SUPER\nLIKE', Colors.blue);
        _onUserSuperLiked(previousIndex);
        break;
      case CardSwiperDirection.bottom:
        // Optional: Handle bottom swipe (maybe for reporting)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppText.comingSoon)),
        );
        break;
      case CardSwiperDirection.none:
        // TODO: Handle this case.
        break;
    }
    
    return true;
  }

  void _onUserLiked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Liked: ${user.name}');
      // TODO: Implement like logic (API call, match checking, etc.)
    }
  }

  void _onUserDisliked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Disliked: ${user.name}');
      // TODO: Implement dislike logic (API call, etc.)
    }
  }

  void _onUserSuperLiked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Super Liked: ${user.name}');
      // TODO: Implement super like logic (API call, premium feature check, etc.)
      
      // Show special animation or notification for super like
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(FontAwesomeIcons.star, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Super Liked ${user.name}!'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main card swiper
          Positioned.fill(
            child: _users.isEmpty
                ? _buildEmptyState()
                : CardSwiper(
                    controller: _swiperController,
                    cardsCount: _users.length,
                    onSwipe: _onSwipe,
                    numberOfCardsDisplayed: 3,
                    backCardOffset: const Offset(0, 40),
                    padding: const EdgeInsets.fromLTRB(20, 80, 20, 140),
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,   // Dislike
                      right: true,  // Like
                      up: true,     // Super Like
                      down: false,  // Disable down swipe for now
                    ),
                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                      return Stack(
                        children: [
                          UserCard(user: _users[index]),
                          
                          // Swipe direction indicators
                          if (percentThresholdX > 0.1) // Swiping right (like)
                            Positioned(
                              top: 50,
                              left: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(FontAwesomeIcons.heart, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'LIKE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          if (percentThresholdX < -0.1) // Swiping left (dislike)
                            Positioned(
                              top: 50,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(FontAwesomeIcons.xmark, color: Colors.white, size: 16),
                                    SizedBox(width: 8),
                                    Text(
                                      'NOPE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          
                          if (percentThresholdY < -0.1) // Swiping up (super like)
                            Positioned(
                              bottom: 50,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.star, color: Colors.white, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        'SUPER LIKE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),

          // Feedback overlays with animations
          if (_showLikeFeedback) _buildFeedbackOverlay('LIKE', Colors.green),
          if (_showDislikeFeedback) _buildFeedbackOverlay('NOPE', Colors.red),
          if (_showSuperLikeFeedback) _buildFeedbackOverlay('SUPER\nLIKE', Colors.blue),

          // Action buttons
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: _buildActionButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.heartCrack,
                size: 60,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppText.noMoreCards,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Check back later for new profiles!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackOverlay(String text, Color color) {
    return AnimatedBuilder(
      animation: _feedbackController,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: color.withOpacity(0.1 * _feedbackOpacity.value),
            child: Center(
              child: Transform.scale(
                scale: _feedbackScale.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: FontAwesomeIcons.rotateLeft,
            color: Colors.amber,
            onPressed: _handleUndo,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.xmark,
            color: Colors.red,
            onPressed: _handleDislike,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.star,
            color: Colors.blue,
            size: 65,
            onPressed: _handleSuperLike,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.heart,
            color: Colors.green,
            onPressed: _handleLike,
          ),
          _buildActionButton(
            icon: FontAwesomeIcons.bolt,
            color: Colors.purple,
            onPressed: () {
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppText.love)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 55,
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
  }}