import 'dart:ui';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/screens/home/widgets/user_card.dart';
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
  final List<User> _filteredUsers = [];
  bool _showLikeFeedback = false;
  bool _showDislikeFeedback = false;
  bool _showSuperLikeFeedback = false;
  bool _isGridView = false;
  bool _showFilters = false;

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
    _loadDummyUsers();
    _setupAnimations();
    _applyFilters();
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
      profileImageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      profileImages: [
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      ],
      bio: 'Adventure seeker and coffee lover ☕ Love exploring new places and meeting interesting people! 🌍✈️',
      interests: ['Hiking', 'Photography', 'Travel', 'Coffee', 'Art'],
      isOnline: true,
      lastActive: DateTime.now(),
      isVerified: true,
      hobbies: ['Photography', 'Traveling', 'Coffee tasting'],
      socialMediaLinks: [
        'instagram:@jessica_adventures',
        'facebook:jessica.nyc',
        'whatsapp:+1555123456',
        'tiktok:@jessicanyc',
        'spotify:jessica-playlist'
      ],
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
      profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      profileImages: [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      ],
      bio: 'Musician by night, developer by day 🎸💻 Looking for someone to share adventures with!',
      interests: ['Music', 'Coding', 'Gaming', 'Movies', 'Food'],
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      socialMediaLinks: [
        'facebook:alex.music',
        'whatsapp:+1234567890',
        'instagram:@alex_codes'
      ],
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
      profileImageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      profileImages: [
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1524250502761-1ac6f2e30d43?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      ],
      bio: 'Yoga instructor and mindfulness coach 🧘‍♀️ Spreading positive vibes everywhere I go ✨',
      interests: ['Yoga', 'Meditation', 'Wellness', 'Nature', 'Books'],
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 36)),
      socialMediaLinks: [
        'instagram:@sofia_yoga',
        'facebook:sofia.barcelona',
        'whatsapp:+34666777888',
        'youtube:@SofiaWellness',
        'linkedin:sofia-martinez'
      ],
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
      profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      profileImages: [
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      ],
      bio: 'Fitness enthusiast and outdoor lover 🏋️‍♂️🏖️ Life is better with good company!',
      interests: ['Fitness', 'Surfing', 'Cooking', 'Travel', 'Dogs'],
      isOnline: false,
      lastActive: DateTime.now().subtract(const Duration(hours: 12)),
      socialMediaLinks: [
        'instagram:@david_fitness',
        'facebook:david.sydney',
        'whatsapp:+61400123456',
        'strava:david-sydney',
        'twitter:@davidfitness'
      ],
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
      profileImageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      profileImages: [
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      'https://images.unsplash.com/photo-1488716820095-cbe80883c496?ixlib=rb-4.0.3&auto=format&fit=crop&w=687&h=1000',
      ],
      bio: 'Artist and creative soul 🎨 Always looking for inspiration in everyday moments',
      interests: ['Art', 'Painting', 'Museums', 'Wine', 'Culture'],
      isOnline: true,
      lastActive: DateTime.now(),
      socialMediaLinks: [
        'instagram:@emma_art',
        'facebook:emma.london',
        'whatsapp:+447700123456',
        'behance:emma-designs',
        'pinterest:emma-creative'
      ],
      ),
      ]);
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredUsers.clear();
      _filteredUsers.addAll(_users.where((user) {
        // Age filter
        if (user.age! < _ageRange.start || user.age! > _ageRange.end) return false;

        // Gender filter
        if (_selectedGender != 'Everyone' && user.gender != _selectedGender) return false;

        // Location filter
        if (_selectedLocation != 'All Locations' && user.location != _selectedLocation) return false;

        // Online filter
        if (_onlineOnly && !user.isOnline) return false;

        // Interests filter
        if (_selectedInterests.isNotEmpty) {
          bool hasMatchingInterest = false;
          for (String interest in _selectedInterests) {
            if (user.interests?.contains(interest) == true) {
              hasMatchingInterest = true;
              break;
            }
          }
          if (!hasMatchingInterest) return false;
        }

        return true;
      }));
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
      print('Liked: ${user.name}');
    }
  }

  void _onUserDisliked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Disliked: ${user.name}');
    }
  }

  void _onUserSuperLiked(int index) {
    if (index < _users.length) {
      final user = _users[index];
      print('Super Liked: ${user.name}');

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

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // View toggle button
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewToggleButton(
                  theme,
                  icon: FontAwesomeIcons.layerGroup,
                  isActive: !_isGridView,
                  onPressed: () => setState(() => _isGridView = false),
                ),
                _buildViewToggleButton(
                  theme,
                  icon: FontAwesomeIcons.tableCells,
                  isActive: _isGridView,
                  onPressed: () => setState(() => _isGridView = true),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Grid View label
          Text(
            _isGridView ? 'Grid View' : 'Card View',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),

          const Spacer(),

          // Filter button
          Container(
            decoration: BoxDecoration(
              color: _showFilters
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => setState(() => _showFilters = !_showFilters),
              icon: FaIcon(
                FontAwesomeIcons.sliders,
                color: _showFilters
                    ? Colors.white
                    : theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(ThemeData theme, {
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: isActive
              ? Colors.white
              : theme.colorScheme.primary,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildFiltersPanel(ThemeData theme) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Age & Distance Filter Section
            _buildExpandableFilterSection(
              theme,
              title: 'Age & Distance',
              icon: FontAwesomeIcons.sliders,
              color: Colors.pink,
              isExpanded: _isAgeFilterExpanded,
              onToggle: () => setState(() => _isAgeFilterExpanded = !_isAgeFilterExpanded),
              content: _buildAgeDistanceContent(theme),
            ),

            const SizedBox(height: 12),

            // Location Filter Section
            _buildExpandableFilterSection(
              theme,
              title: 'Location & Gender',
              icon: FontAwesomeIcons.locationDot,
              color: Colors.blue,
              isExpanded: _isLocationFilterExpanded,
              onToggle: () => setState(() => _isLocationFilterExpanded = !_isLocationFilterExpanded),
              content: _buildLocationGenderContent(theme),
            ),

            const SizedBox(height: 12),

            // Preferences Filter Section
            _buildExpandableFilterSection(
              theme,
              title: 'Preferences',
              icon: FontAwesomeIcons.heart,
              color: Colors.purple,
              isExpanded: _isPreferencesFilterExpanded,
              onToggle: () => setState(() => _isPreferencesFilterExpanded = !_isPreferencesFilterExpanded),
              content: _buildPreferencesContent(theme),
            ),

            const SizedBox(height: 12),

            // Interests Filter Section
            _buildExpandableFilterSection(
              theme,
              title: 'Interests',
              icon: FontAwesomeIcons.star,
              color: Colors.green,
              isExpanded: _isInterestsFilterExpanded,
              onToggle: () => setState(() => _isInterestsFilterExpanded = !_isInterestsFilterExpanded),
              content: _buildInterestsFilterContent(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableFilterSection(
      ThemeData theme, {
        required String title,
        required IconData icon,
        required Color color,
        required bool isExpanded,
        required VoidCallback onToggle,
        required Widget content,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      icon,
                      color: color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      color: color,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isExpanded ? 1.0 : 0.0,
              child: isExpanded ? Container(
                padding: const EdgeInsets.all(16),
                child: content,
              ) : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeDistanceContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Age Range: ${_ageRange.start.round()} - ${_ageRange.end.round()}',
            style: theme.textTheme.titleSmall),
        RangeSlider(
          values: _ageRange,
          min: 18,
          max: 60,
          divisions: 42,
          activeColor: Colors.pink,
          onChanged: (values) {
            setState(() => _ageRange = values);
            _applyFilters();
          },
        ),
        const SizedBox(height: 16),
        Text('Distance: ${_distance.round()} km', style: theme.textTheme.titleSmall),
        Slider(
          value: _distance,
          min: 1,
          max: 100,
          divisions: 99,
          activeColor: Colors.pink,
          onChanged: (value) {
            setState(() => _distance = value);
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildLocationGenderContent(ThemeData theme) {
    final allLocations = ['All Locations', 'New York', 'Toronto', 'Barcelona', 'Sydney', 'London'];

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: _selectedGender,
          items: ['Everyone', 'Male', 'Female']
              .map((gender) => DropdownMenuItem(
            value: gender,
            child: Text(gender),
          ))
              .toList(),
          onChanged: (value) {
            setState(() => _selectedGender = value!);
            _applyFilters();
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: _selectedLocation,
          items: allLocations
              .map((location) => DropdownMenuItem(
            value: location,
            child: Text(location),
          ))
              .toList(),
          onChanged: (value) {
            setState(() => _selectedLocation = value!);
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesContent(ThemeData theme) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Online Only'),
          subtitle: const Text('Show only users currently online'),
          value: _onlineOnly,
          activeColor: Colors.purple,
          onChanged: (value) {
            setState(() => _onlineOnly = value);
            _applyFilters();
          },
        ),
      ],
    );
  }

  Widget _buildInterestsFilterContent(ThemeData theme) {
    final allInterests = ['Hiking', 'Photography', 'Travel', 'Coffee', 'Art', 'Music', 'Coding', 'Gaming', 'Movies', 'Food', 'Yoga', 'Meditation', 'Wellness', 'Nature', 'Books', 'Fitness', 'Surfing', 'Cooking', 'Dogs', 'Painting', 'Museums', 'Wine', 'Culture'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select interests to match',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: allInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              selectedColor: Colors.green.withOpacity(0.2),
              checkmarkColor: Colors.green,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest);
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
                _applyFilters();
              },
            );
          }).toList(),
        ),
      ],
    );
  }

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
        return _buildCompactUserCard(user, index);
      },
    );
  }

  //grid view tabs
  Widget _buildCompactUserCard(User user, int index) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _showUserDetailModal(user),
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
                  user.profileImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: theme.colorScheme.surface,
                    child: Icon(
                      Icons.person, 
                      size: 50, 
                      color: theme.colorScheme.onSurface.withOpacity(0.5)
                    ),
                  ),
                ),
              ),

              // Gradient overlay with theme colors
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

              // Top indicators row
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    // Social media indicators with theme styling
                    if (user.socialMediaLinks.isNotEmpty)
                      Container(
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
                      ),
                    const Spacer(),
                    // Online indicator with theme colors
                    if (user.isOnline)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface, 
                            width: 2
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Verification badge with theme colors
              if (user.isVerified)
                Positioned(
                  top: 12,
                  right: user.isOnline ? 32 : 12,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface, 
                        width: 1
                      ),
                    ),
                    child: Icon(
                      Icons.verified,
                      color: theme.colorScheme.surface,
                      size: 12,
                    ),
                  ),
                ),

           
              Positioned(
                bottom: 55, // Adjusted for social media bar
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${user.name}, ${user.age}',
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
                      // Interests chips with theme colors
                      if (user.interests.isNotEmpty)
                        SizedBox(
                          height: 20,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: user.interests.length.clamp(0, 2),
                            itemBuilder: (context, i) {
                              return Container(
                                margin: const EdgeInsets.only(right: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
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
                ),
              ),

              // Action buttons at bottom with glassmorphism design using theme colors
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 50,
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
                      child: Row(
                        children: [
                          // Dislike button
                          Expanded(
                            child: _buildEnhancedActionButton(
                              icon: FontAwesomeIcons.xmark,
                              color: theme.colorScheme.error,
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _onUserDisliked(index);
                                _removeUserFromGrid(user);
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                          // Super like button
                          Expanded(
                            child: _buildEnhancedActionButton(
                              icon: FontAwesomeIcons.star,
                              color: theme.colorScheme.primary,
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                _onUserSuperLiked(index);
                                _removeUserFromGrid(user);
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                          // Like button
                          Expanded(
                            child: _buildEnhancedActionButton(
                              icon: FontAwesomeIcons.heart,
                              color: theme.colorScheme.secondary,
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _onUserLiked(index);
                                _removeUserFromGrid(user);
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                          // More options button
                          Expanded(
                            child: _buildEnhancedActionButton(
                              icon: FontAwesomeIcons.ellipsis,
                              color: theme.colorScheme.onSurface,
                              onPressed: () {
                                _showMoreOptions(user, index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
      builder: (context) => _buildUserDetailModalContent(user),
    );
  }

  //grid view details of user
  Widget _buildUserDetailModalContent(User user) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile images carousel
                    _buildProfileImagesCarousel(user),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name, age and location
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${user.name}, ${user.age}',
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (user.isVerified)
                                          const Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 24,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          user.location,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Distance indicator
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${((_users.indexOf(user) % 10) * 3 + 2)} km',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Bio
                          if (user.bio != null && user.bio!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.bio!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),

                          // Social media section
                          if (user.socialMediaLinks.isNotEmpty) ...[
                            const Text(
                              'Connect with me',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: user.socialMediaLinks.take(4).map((link) {
                                final platform = link.split(':')[0].toLowerCase();
                                final username = link.split(':').length > 1 ? link.split(':')[1] : '';
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () => _handleSocialMediaTap(link),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getSocialMediaColor(link).withOpacity(0.8),
                                            _getSocialMediaColor(link).withOpacity(0.6),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: _getSocialMediaColor(link).withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: _getSocialMediaIconLarge(link),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Interests section
                          if (user.interests.isNotEmpty) ...[
                            const Text(
                              'Interests',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: user.interests.map((interest) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    interest,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Additional info
                          _buildDetailRow('Gender', user.gender),
                          _buildDetailRow('Nationality', user.nationality),
                          if (user.hobbies.isNotEmpty)
                            _buildDetailRow('Hobbies', user.hobbies.join(', ')),

                          const SizedBox(height: 80), // Space for action buttons
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                      color: Colors.red,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModalActionButton(
                      icon: FontAwesomeIcons.heart,
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context);
                        _onUserLiked(_users.indexOf(user));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImagesCarousel(User user) {
    return SizedBox(
      height: 400,
      child: PageView.builder(
        itemCount: user.profileImages.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(user.profileImages[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Page indicator
                if (user.profileImages.length > 1)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: List.generate(
                        user.profileImages.length,
                            (i) => Expanded(
                          child: Container(
                            height: 3,
                            margin: EdgeInsets.only(
                              right: i == user.profileImages.length - 1 ? 0 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: i == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Online indicator
                if (user.isOnline)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
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
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: 45,
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 50,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.6),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSocialMediaTap(String socialLink) {
    final parts = socialLink.split(':');
    final platform = parts[0].toLowerCase();
    final handle = parts.length > 1 ? parts[1] : '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _getSocialMediaIcon(socialLink),
            const SizedBox(width: 8),
            Text('Open $platform: $handle'),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );

    // Here you would typically open the social media app or website
    // For example: launchUrl() or custom deep links
  }

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
                _buildMoreOptionItem(
                  icon: FontAwesomeIcons.eye,
                  title: 'View Full Profile',
                  color: const Color(0xFF6B46C1),
                  onTap: () {
                    Navigator.pop(context);
                    _showUserDetailModal(user);
                  },
                ),
                _buildMoreOptionItem(
                  icon: FontAwesomeIcons.flag,
                  title: 'Report User',
                  color: const Color(0xFFDC2626),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(user);
                  },
                ),
                _buildMoreOptionItem(
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

  Widget _buildMoreOptionItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.8),
              color.withOpacity(0.6),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  void _showReportDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: Text('Report ${user.name} for inappropriate behavior?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.name} has been reported')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
            child: const Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _getSocialMediaIcon(String socialLink) {
    final platform = socialLink.split(':')[0].toLowerCase();
    IconData icon;
    Color color = Colors.white;

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
      case 'spotify':
        icon = FontAwesomeIcons.spotify;
        color = const Color(0xFF1DB954);
        break;
      case 'youtube':
        icon = FontAwesomeIcons.youtube;
        color = const Color(0xFFFF0000);
        break;
      case 'linkedin':
        icon = FontAwesomeIcons.linkedin;
        color = const Color(0xFF0077B5);
        break;
      case 'twitter':
        icon = FontAwesomeIcons.twitter;
        color = const Color(0xFF1DA1F2);
        break;
      case 'behance':
        icon = FontAwesomeIcons.behance;
        color = const Color(0xFF1769FF);
        break;
      case 'pinterest':
        icon = FontAwesomeIcons.pinterest;
        color = const Color(0xFFBD081C);
        break;
      case 'strava':
        icon = FontAwesomeIcons.strava;
        color = const Color(0xFFFC4C02);
        break;
      default:
        icon = FontAwesomeIcons.link;
        color = Colors.white;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FaIcon(
          icon,
          size: 9,
          color: Colors.white,
        ),
      ),
    );
  }

  // Get social media icon for modal view (larger size)
  Widget _getSocialMediaIconLarge(String socialLink) {
    final platform = socialLink.split(':')[0].toLowerCase();
    IconData icon;

    switch (platform) {
      case 'instagram':
        icon = FontAwesomeIcons.instagram;
        break;
      case 'facebook':
        icon = FontAwesomeIcons.facebook;
        break;
      case 'whatsapp':
        icon = FontAwesomeIcons.whatsapp;
        break;
      case 'tiktok':
        icon = FontAwesomeIcons.tiktok;
        break;
      case 'spotify':
        icon = FontAwesomeIcons.spotify;
        break;
      case 'youtube':
        icon = FontAwesomeIcons.youtube;
        break;
      case 'linkedin':
        icon = FontAwesomeIcons.linkedin;
        break;
      case 'twitter':
        icon = FontAwesomeIcons.twitter;
        break;
      case 'behance':
        icon = FontAwesomeIcons.behance;
        break;
      case 'pinterest':
        icon = FontAwesomeIcons.pinterest;
        break;
      case 'strava':
        icon = FontAwesomeIcons.strava;
        break;
      default:
        icon = FontAwesomeIcons.link;
    }

    return FaIcon(
      icon,
      size: 18,
      color: Colors.white,
    );
  }

  // Get social media brand color for circles
  Color _getSocialMediaColor(String socialLink) {
    final platform = socialLink.split(':')[0].toLowerCase();
    
    switch (platform) {
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'tiktok':
        return Colors.black;
      case 'spotify':
        return const Color(0xFF1DB954);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'linkedin':
        return const Color(0xFF0077B5);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'behance':
        return const Color(0xFF1769FF);
      case 'pinterest':
        return const Color(0xFFBD081C);
      case 'strava':
        return const Color(0xFFFC4C02);
      default:
        return Colors.grey;
    }
  }

  void _removeUserFromGrid(User user) {
    setState(() {
      _users.remove(user);
      _filteredUsers.remove(user);
    });
  }

  Widget _buildSocialMediaChip(String socialLink) {
    final parts = socialLink.split(':');
    final platform = parts[0].toLowerCase();
    final username = parts.length > 1 ? parts[1] : '';
    
    final icon = _getSocialMediaIcon(socialLink);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            username.startsWith('@') ? username : '@$username',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
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

  Widget _buildFeedbackOverlay(String text, Color color, IconData icon) {
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        icon,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
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
          _buildHeader(theme),

          // Filter options (shown when _showFilters is true)
          if (_showFilters) _buildFiltersPanel(theme),

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
                if (!_isGridView && _showLikeFeedback) _buildFeedbackOverlay('LIKE', Colors.green, FontAwesomeIcons.heart),
                if (!_isGridView && _showDislikeFeedback) _buildFeedbackOverlay('NOPE', Colors.red, FontAwesomeIcons.heartCrack),
                if (!_isGridView && _showSuperLikeFeedback) _buildFeedbackOverlay('SUPER\nLIKE', Colors.blue, FontAwesomeIcons.star),

                // Action buttons (only for card view)
                if (!_isGridView) Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: _buildActionButtons(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}