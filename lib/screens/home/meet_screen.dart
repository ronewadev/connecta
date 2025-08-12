import 'dart:ui';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/screens/home/widgets/action_button.dart';
import 'package:connecta/screens/home/widgets/action_buttons.dart';
import 'package:connecta/screens/home/widgets/compact_user_card.dart';
import 'package:connecta/screens/home/widgets/feedback_overlay.dart';
import 'package:connecta/screens/home/widgets/filter_interests.dart';
import 'package:connecta/screens/home/widgets/filter_panel.dart';
import 'package:connecta/screens/home/widgets/more_options_item.dart';
import 'package:connecta/screens/home/widgets/profile_image_carousel.dart';
import 'package:connecta/screens/home/widgets/social_chips.dart';
import 'package:connecta/screens/home/widgets/theme_data.dart';
import 'package:connecta/screens/home/widgets/user_details_modal.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/screens/home/widgets/user_card.dart';
import 'package:connecta/functions/match_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/profile_data_service.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> with TickerProviderStateMixin {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<User> _users = [];
  final List<User> _filteredUsers = [];
  bool _showLikeFeedback = false;
  bool _showDislikeFeedback = false;
  bool _showSuperLikeFeedback = false;
  bool _isGridView = false;
  bool _showFilters = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Filter options
  RangeValues _ageRange = const RangeValues(18, 35);
  double _distance = 50.0;
  String _selectedGender = 'Everyone';
  String _selectedLocation = 'All Locations';
  List<String> _selectedInterests = [];
  bool _onlineOnly = false;

  // Expandable filter sections
  bool _isAgeFilterExpanded = false;
  bool _isLocationFilterExpanded = false;
  bool _isPreferencesFilterExpanded = false;
  bool _isInterestsFilterExpanded = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late Animation<double> _feedbackOpacity;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadMatches();
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

  /// Load real user matches from Firestore
  Future<void> _loadMatches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('DEBUG: Starting to load matches...');
      print('DEBUG: Filter parameters - Distance: $_distance, Age: ${_ageRange.start.round()}-${_ageRange.end.round()}');

      // Get matches using the matching service
      final matches = await MatchUsersService.findMatches();

      print('DEBUG: Found ${matches.length} matches from service');
      for (var match in matches) {
        print('DEBUG: Match - ${match.username}, Age: ${match.age}, Gender: ${match.gender}');
      }

      setState(() {
        _users.clear();
        _users.addAll(matches);
        _isLoading = false;
      });

      // Apply any active filters
      _applyFilters();

      // If still no matches after all attempts, create some debug info
      if (_filteredUsers.isEmpty) {
        print('DEBUG: No filtered users found. Total users: ${_users.length}');
        print('DEBUG: No filtered users found. Total users: ${_users.length}');
        print('DEBUG: Current filters - Age: ${_ageRange.start}-${_ageRange.end}, Gender: $_selectedGender, Online: $_onlineOnly');

        // Show all users if no filters are restrictive
        if (_selectedGender == 'Everyone' && !_onlineOnly) {
          setState(() {
            _filteredUsers.addAll(_users);
          });
          print('DEBUG: Added all users to filtered list as fallback');
        }
      }

      print('DEBUG: Final result - ${_filteredUsers.length} users ready to display');

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load matches: ${e.toString()}';
      });

      print('Error loading matches: $e');

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load matches. Please try again.'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _loadMatches,
            ),
          ),
        );
      }
    }
  }

  /// Refresh matches with current filters
  void _applyFilters() {
    if (_users.isEmpty) {
      setState(() {
        _filteredUsers.clear();
      });
      return;
    }

    setState(() {
      _filteredUsers.clear();
      _filteredUsers.addAll(_users.where((user) {
        // Age filter - be more lenient with +/- 2 years
        if (user.age < (_ageRange.start - 2) || user.age > (_ageRange.end + 2)) return false;

        // Gender filter - ALWAYS respect this (non-negotiable)
        if (_selectedGender != 'Everyone' && user.gender != _selectedGender) return false;

        // Online filter - only apply if explicitly requested
        if (_onlineOnly && !user.isOnline) return false;

        // Interests filter - be more lenient, don't filter out completely
        // Let the scoring handle interest compatibility instead
        if (_selectedInterests.isNotEmpty) {
          // Still check but don't reject based on this alone
          final hasMatchingInterest = _selectedInterests.any((interest) =>
              user.interests.any((userInterest) =>
                  userInterest.toLowerCase().contains(interest.toLowerCase()) ||
                  interest.toLowerCase().contains(userInterest.toLowerCase()))
          );
          // We'll sort by compatibility in the UI instead of filtering out
        }

        return true;
      }));

      // If we have no filtered users but have original users, show all users except gender mismatches
      if (_filteredUsers.isEmpty && _users.isNotEmpty) {
        print('DEBUG: No users passed filters, applying only gender filter');
        _filteredUsers.addAll(_users.where((user) {
          // Only apply gender filter as absolute requirement
          return _selectedGender == 'Everyone' || user.gender == _selectedGender;
        }));
      }
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

    // Handle different swipe directions
    switch (direction) {
      case CardSwiperDirection.left:
        _showFeedback('NOPE', Colors.red, FontAwesomeIcons.heartCrack);
        _onUserDisliked(previousIndex);
        break;
      case CardSwiperDirection.right:
        _showFeedback('LIKE', Colors.green, FontAwesomeIcons.heart);
        _onUserLiked(previousIndex);
        break;
      case CardSwiperDirection.top:
        _showFeedback('SUPER\nLIKE', Colors.blue, FontAwesomeIcons.star);
        _onUserSuperLiked(previousIndex);
        break;
      case CardSwiperDirection.bottom:
      // Optional: Handle bottom swipe (maybe for reporting)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppText.comingSoon)),
        );
        break;
      case CardSwiperDirection.none:
        break;
    }

    return true;
  }

  void _onUserLiked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Liked: ${user.username}');
    }
  }

  void _onUserDisliked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Disliked: ${user.username}');
    }
  }

  void _onUserSuperLiked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Super Liked: ${user.username}');

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
  }


  //grid view tabs
  Widget _buildGridView(List<User> users) {
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

  Widget _buildCardView(List<User> users) {
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
            UserCard(user: users[index]),

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
    );
  }

  void _showUserDetailModal(User user) {
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

  //grid view details of user
  void _showMoreOptions(User user, int index) {
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

  void _showReportDialog(User user) {
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

  void _removeUserFromGrid(User user) {
    setState(() {
      _users.remove(user);
      _filteredUsers.remove(user);
    });
  }

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
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            interest,
            style: TextStyle(
              color: theme.colorScheme.primary,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool filtersActive = _ageRange.start != 18 || _ageRange.end != 35 ||
        _selectedGender != 'Everyone' ||
        _selectedLocation != 'All Locations' ||
        _onlineOnly ||
        _selectedInterests.isNotEmpty;

    final List<User> currentUsers = filtersActive ? _filteredUsers : _users;

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
              // Handle updated filters here
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