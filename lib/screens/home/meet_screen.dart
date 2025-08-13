import 'dart:ui';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/screens/home/widgets/user_card.dart';
import 'package:connecta/screens/home/widgets/view_header.dart'; // Add this import
import 'package:connecta/services/match_service.dart';
import 'package:connecta/screens/home/widgets/action_buttons.dart';
import 'package:connecta/screens/home/widgets/compact_user_card.dart';
import 'package:connecta/screens/home/widgets/feedback_overlay.dart';
import 'package:connecta/screens/home/widgets/filter_panel.dart';
import 'package:connecta/screens/home/widgets/more_options_item.dart';
import 'package:connecta/screens/home/widgets/profile_image_carousel.dart';
import 'package:connecta/screens/home/widgets/theme_data.dart' hide ViewHeader;
import 'package:connecta/screens/home/widgets/user_details_modal.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/match_score_model.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> with TickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<UserModelInfo> _users = [];
  final List<UserModelInfo> _filteredUsers = [];
  bool _showLikeFeedback = false;
  bool _showDislikeFeedback = false;
  bool _showSuperLikeFeedback = false;
  bool _isGridView = false;
  bool _showFilters = false;
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  int _currentCardIndex = 0; // Track current card index manually

  // Animation controllers
  late AnimationController _feedbackController;

  // Filter options
  RangeValues _ageRange = const RangeValues(18, 35);
  double _distance = 50.0;
  String _selectedGender = 'Everyone';
  String _selectedLocation = 'All Locations';
  List<String> _selectedInterests = [];
  bool _onlineOnly = false;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser?.uid;
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _setupRealtimeMatches();
  }

  /// Set up real-time matches stream
  void _setupRealtimeMatches() {
    print('🚀 MeetScreen: Setting up realtime matches...');
    print('👤 Current user ID: $_currentUserId');
    
    MatchService.getPotentialMatchesStream(limit: 50).listen(
      (matches) {
        print('📊 MeetScreen: Received ${matches.length} matches from stream');
        matches.forEach((match) {
          // Fix: Use correct property names for UserModelInfo
          print('   🎯 Match: ${match.username} (${match.id}) - Age: ${match.age}');
        });
        
        if (mounted) {
          setState(() {
            _users.clear();
            _users.addAll(matches);  // Remove the incorrect casting
            _isLoading = false;
            _errorMessage = null;
            _currentCardIndex = 0; // Reset index when new users load
          });
          print('✅ MeetScreen: State updated with ${_users.length} users');
          _applyFilters();
        }
      },
      onError: (error) {
        print('💥 MeetScreen: Stream error - $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to load matches: ${error.toString()}';
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  /// Refresh matches with current filters
  void _applyFilters() {
    print('🔍 MeetScreen: Applying filters...');
    print('📊 Original users count: ${_users.length}');
    print('🎚️ Filters - Age: $_ageRange, Gender: $_selectedGender, Online: $_onlineOnly');
    
    if (_users.isEmpty) {
      print('❌ No users to filter');
      setState(() {
        _filteredUsers.clear();
      });
      return;
    }

    setState(() {
      _filteredUsers.clear();
      _filteredUsers.addAll(_users.where((user) {
        print('🧪 Testing user ${user.username}:');
        print('   Age: ${user.age} (range: ${_ageRange.start}-${_ageRange.end})');
        print('   Gender: ${user.gender} (filter: $_selectedGender)');
        print('   Online: ${user.isOnline} (filter: $_onlineOnly)');
        
        // Age filter - be more lenient with +/- 2 years
        if (user.age < (_ageRange.start - 2) || user.age > (_ageRange.end + 2)) {
          print('   ❌ Failed age filter');
          return false;
        }

        // Gender filter - ALWAYS respect this (non-negotiable)
        if (_selectedGender != 'Everyone' && user.gender != _selectedGender) {
          print('   ❌ Failed gender filter');
          return false;
        }

        // Online filter - only apply if explicitly requested
        if (_onlineOnly && !user.isOnline) {
          print('   ❌ Failed online filter');
          return false;
        }

        print('   ✅ Passed all filters');
        return true;
      }));

      print('📊 Filtered users count: ${_filteredUsers.length}');

      // If we have no filtered users but have original users, show all users except gender mismatches
      if (_filteredUsers.isEmpty && _users.isNotEmpty) {
        print('🔄 No users passed filters, applying only gender filter');
        _filteredUsers.addAll(_users.where((user) {
          // Only apply gender filter as absolute requirement
          final passes = _selectedGender == 'Everyone' || user.gender == _selectedGender;
          print('   ${user.username}: ${passes ? "✅" : "❌"} gender filter');
          return passes;
        }));
        print('📊 After relaxed filtering: ${_filteredUsers.length} users');
      }

      // Reset card index when filters change
      _currentCardIndex = 0;
    });
    
    print('✅ Filter application complete');
  }

  /// Handle like action with real-time update
  void _handleLike() async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (currentUsers.isEmpty || _currentCardIndex >= currentUsers.length) return;
    
    HapticFeedback.lightImpact();
    
    final user = currentUsers[_currentCardIndex];
    final success = await MatchService.recordInteraction(
      toUserId: user.id,
      type: InteractionType.like,
    );
    
    if (success) {
      _showFeedback('LIKE', Colors.green, FontAwesomeIcons.heart);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Liked ${user.username}!')),
      );
    }
    
    _swiperController.swipe(CardSwiperDirection.right);
  }

  /// Handle dislike action
  void _handleDislike() async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (currentUsers.isEmpty || _currentCardIndex >= currentUsers.length) return;
    
    HapticFeedback.lightImpact();
    
    final user = currentUsers[_currentCardIndex];
    await MatchService.recordInteraction(
      toUserId: user.id,
      type: InteractionType.dislike,
    );
    _showFeedback('NOPE', Colors.red, FontAwesomeIcons.heartCrack);
    
    _swiperController.swipe(CardSwiperDirection.left);
  }

  /// Handle super like action
  void _handleSuperLike() async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (currentUsers.isEmpty || _currentCardIndex >= currentUsers.length) return;
    
    HapticFeedback.mediumImpact();
    
    final user = currentUsers[_currentCardIndex];
    final success = await MatchService.recordInteraction(
      toUserId: user.id,
      type: InteractionType.superLike,
    );
    
    if (success) {
      _showFeedback('SUPER\nLIKE', Colors.blue, FontAwesomeIcons.star);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(FontAwesomeIcons.star, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text('Super Liked ${user.username}!'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    
    _swiperController.swipe(CardSwiperDirection.top);
  }

  /// Handle undo action
  void _handleUndo() {
    HapticFeedback.lightImpact();
    try {
      _swiperController.undo();
      // Decrease the current index when undoing
      if (_currentCardIndex > 0) {
        setState(() {
          _currentCardIndex--;
        });
      }
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
          ));

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No more actions to undo')),
        );
      }
    }

  void _showFeedback(String text, Color color, IconData icon) {
    setState(() {
      _showLikeFeedback = text == 'LIKE';
      _showDislikeFeedback = text == 'NOPE';
      _showSuperLikeFeedback = text == 'SUPER\nLIKE';
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

    // Update our manual index tracking
    setState(() {
      _currentCardIndex = currentIndex ?? _currentCardIndex + 1;
    });

    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (previousIndex >= currentUsers.length) return true;

    final user = currentUsers[previousIndex];

    // Handle different swipe directions
    switch (direction) {
      case CardSwiperDirection.left:
        MatchService.recordInteraction(
          toUserId: user.id,
          type: InteractionType.dislike,
        );
        _showFeedback('NOPE', Colors.red, FontAwesomeIcons.heartCrack);
        break;
      case CardSwiperDirection.right:
        MatchService.recordInteraction(
          toUserId: user.id,
          type: InteractionType.like,
        ).then((success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Liked ${user.username}!')),
            );
          }
        });
        _showFeedback('LIKE', Colors.green, FontAwesomeIcons.heart);
        break;
      case CardSwiperDirection.top:
        MatchService.recordInteraction(
          toUserId: user.id,
          type: InteractionType.superLike,
        ).then((success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text('Super Liked ${user.username}!'),
                  ],
                ),
                backgroundColor: Colors.blue,
              ),
            );
          }
        });
        _showFeedback('SUPER\nLIKE', Colors.blue, FontAwesomeIcons.star);
        break;
      case CardSwiperDirection.bottom:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppText.comingSoon)),
        );
        break;
      case CardSwiperDirection.none:
        break;
    }

    return true;
  }

  //grid view tabs
  Widget _buildGridView(List<UserModelInfo> users) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68, // Slightly taller to accommodate controls
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return CompactUserCard(
          user: users[index],
          index: index,
          onTap: () => _showUserDetailModal(users[index]),
          onDislike: () => _onUserDisliked(index),
          onSuperLike: () => _onUserSuperLiked(index),
          onLike: () => _onUserLiked(index),
          onMoreOptions: () => _showMoreOptions(users[index], index),
        );
        ;
      },
    );
  }

  Widget _buildCardView(List<UserModelInfo> users) {
    return CardSwiper(
      controller: _swiperController,
      cardsCount: users.length,
      onSwipe: _onSwipe,
      numberOfCardsDisplayed: 3,
      backCardOffset: const Offset(0, 40),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      allowedSwipeDirection: const AllowedSwipeDirection.only(
        left: true,
        right: true,
        up: true,
        down: false,
      ),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        return Stack(
          children: [
            UserCard(
              user: users[index], 
              currentUserId: _currentUserId,
            ),

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
                      FaIcon(FontAwesomeIcons.heartCrack, color: Colors.white, size: 16),
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
                top: 100,
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
    );
  }

  void _showUserDetailModal(UserModelInfo user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserDetailModal(
        user: user,
        profileImagesCarouselBuilder: (u) => ProfileImagesCarousel(user: u),
        interestChipBuilder: _buildInterestChip,
        onDislike: _handleDislike,
        onSuperLike: _handleSuperLike,
        onLike: _handleLike,
        onBoost: () {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boost sent!')),
          );
        },
      ),
    );
  }

  void _onUserLiked(int index) async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (index < currentUsers.length) {
      final user = currentUsers[index];
      await MatchService.recordInteraction(
        toUserId: user.id,
        type: InteractionType.like,
      );
      print('Liked: ${user.username}');
    }
  }

  void _onUserDisliked(int index) async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (index < currentUsers.length) {
      final user = currentUsers[index];
      await MatchService.recordInteraction(
        toUserId: user.id,
        type: InteractionType.dislike,
      );
      print('Disliked: ${user.username}');
    }
  }

  void _onUserSuperLiked(int index) async {
    final currentUsers = _filteredUsers.isNotEmpty ? _filteredUsers : _users;
    if (index < currentUsers.length) {
      final user = currentUsers[index];
      await MatchService.recordInteraction(
        toUserId: user.id,
        type: InteractionType.superLike,
      );
      print('Super Liked: ${user.username}');
    }
  }

  void _removeUserFromGrid(UserModelInfo user) {
    setState(() {
      _users.remove(user);
      _filteredUsers.remove(user);
    });
  }

  //grid view details of user
  void _showMoreOptions(UserModelInfo user, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                MoreOptionItem(
                  icon: FontAwesomeIcons.eye,
                  title: 'View Full Profile',
                  color: const Color(0xFF6B46C1),
                  onTap: () {
                    Navigator.pop(context);
                    _showUserDetailModal(user);
                  },
                ),
                MoreOptionItem(
                  icon: FontAwesomeIcons.flag,
                  title: 'Report User',
                  color: const Color(0xFFDC2626),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(user);
                  },
                ),
                MoreOptionItem(
                  icon: FontAwesomeIcons.eyeSlash,
                  title: 'Hide User',
                  color: const Color(0xFF6B7280),
                  onTap: () {
                    Navigator.pop(context);
                    // Fixed: removed the incorrect casting
                    _removeUserFromGrid(user);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportDialog(UserModelInfo user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Text('Report ${user.username} for inappropriate behavior?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.username} has been reported')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //grid view interest chips
  Widget _buildInterestChip(String interest, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.primary.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            interest,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_outline,
              size: 50,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppText.noMoreCards,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool filtersActive = _ageRange.start != 18 || _ageRange.end != 35 ||
        _selectedGender != 'Everyone' ||
        _selectedLocation != 'All Locations' ||
        _onlineOnly ||
        _selectedInterests.isNotEmpty;

    final List<UserModelInfo> currentUsers = filtersActive ? _filteredUsers : _users;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _setupRealtimeMatches,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header with view toggle and filters
          ViewHeader(
            isGridView: _isGridView,
            showFilters: _showFilters,
            onToggleFilters: () => setState(() => _showFilters = !_showFilters),
            onSwitchToGrid: () => setState(() => _isGridView = true),
            onSwitchToCard: () => setState(() => _isGridView = false),
          ),

          // Filter options (shown when _showFilters is true)
          if (_showFilters)FiltersPanel(
            onFiltersChanged: ({
              required ageRange,
              required distance,
              required gender,
              required location,
              required onlineOnly,
              required interests,
            }) {
              setState(() {
                _ageRange = ageRange;
                _distance = distance;
                _selectedGender = gender;
                _selectedLocation = location;
                _onlineOnly = onlineOnly;
                _selectedInterests = interests;
              });
              _applyFilters();
            },
          ),


          // Main content area
          Expanded(
            child: Stack(
              children: [
                // Main view area
                Positioned.fill(
                  child: currentUsers.isEmpty
                      ? _buildEmptyState()
                      : _isGridView
                      ? _buildGridView(currentUsers)
                      : _buildCardView(currentUsers),
                ),

                // Feedback overlays with animations (only for card view)
                if (!_isGridView && _showLikeFeedback) FeedbackOverlay('LIKE', Colors.green, FontAwesomeIcons.heart),
                if (!_isGridView && _showDislikeFeedback) FeedbackOverlay('NOPE', Colors.red, FontAwesomeIcons.heartCrack),
                if (!_isGridView && _showSuperLikeFeedback) FeedbackOverlay('SUPER\nLIKE', Colors.blue, FontAwesomeIcons.star),

                // Action buttons (only for card view)
                if (!_isGridView) Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: ActionButtonsRow(
                    onUndo: _handleUndo,
                    onDislike: _handleDislike,
                    onSuperLike: _handleSuperLike,
                    onLike: _handleLike,
                    onBoost: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppText.love)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}