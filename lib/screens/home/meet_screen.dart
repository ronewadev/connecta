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
          ],
          bio: 'Fitness enthusiast and outdoor lover 🏋️‍♂️🏖️ Life is better with good company!',
          interests: ['Fitness', 'Surfing', 'Cooking', 'Travel', 'Dogs'],
          isOnline: false,
          lastActive: DateTime.now().subtract(const Duration(hours: 12)),
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
        ),
      );
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
      height: 300, // Fixed height with scroll
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
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUniqueUserCard(user, index);
      },
    );
  }

  Widget _buildUniqueUserCard(User user, int index) {
    final theme = Theme.of(context);
    final isEven = index % 2 == 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 140,
          child: Stack(
            children: [
              // Background with gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isEven 
                          ? [Colors.blue.shade400, Colors.purple.shade400]
                          : [Colors.pink.shade400, Colors.orange.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              
              // Main content row
              Row(
                children: [
                  // Left side - User image
                  Container(
                    width: 120,
                    child: Stack(
                      children: [
                        // Profile image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Image.network(
                              user.profileImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        
                        // Online indicator
                        if (user.isOnline)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1.5),
                              ),
                            ),
                          ),
                        
                        // Action buttons overlay
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildCompactActionButton(
                                FontAwesomeIcons.heart,
                                Colors.green,
                                () => _onUserLiked(index),
                              ),
                              const SizedBox(width: 4),
                              _buildCompactActionButton(
                                FontAwesomeIcons.xmark,
                                Colors.red,
                                () => _onUserDisliked(index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right side - User info
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Name and age
                          Text(
                            '${user.name}, ${user.age}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Location with icon
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.locationDot,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  user.location ?? '',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 6),
                          
                          // Bio preview
                          Text(
                            user.bio ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Interests chips
                          if (user.interests?.isNotEmpty == true)
                            Flexible(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 2,
                                children: user.interests!.take(2).map((interest) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      interest,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Tap overlay for profile view
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showUserProfile(user),
                    child: Container(),
                  ),
                ),
              ),
              
              // Decorative elements
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
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

  Widget _buildCompactActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 12,
            ),
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
        left: true,   // Dislike
        right: true,  // Like
        up: true,     // Super Like
        down: false,  // Disable down swipe for now
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

  void _showUserProfile(User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEnhancedProfileModal(user),
    );
  }

  Widget _buildEnhancedProfileModal(User user) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        user.profileImageUrl!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name and age
                    Text(
                      '${user.name}, ${user.age}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Location
                    Row(
                      children: [
                        const FaIcon(FontAwesomeIcons.locationDot, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(user.location ?? '', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bio
                    Text(
                      user.bio ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    // Interests
                    if (user.interests?.isNotEmpty == true) ...[
                      const Text(
                        'Interests',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: user.interests!.map((interest) {
                          return Chip(
                            label: Text(interest),
                            backgroundColor: Colors.blue.shade50,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ...existing code...

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<User> currentUsers = _isGridView ? _filteredUsers : (_filteredUsers.isEmpty ? _users : _filteredUsers);
    
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
  }}