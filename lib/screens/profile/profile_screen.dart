
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/screens/auth/welcome_screen.dart';
import 'package:connecta/screens/plans/tokens_screen.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart' hide IconButton;

import '../../database/user_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserDatabase _userDatabase = UserDatabase();
  UserData? _userData;
  StreamSubscription<UserData?>? _userDataSubscription;
  
  // Age range slider values
  RangeValues _ageRange = const RangeValues(22, 30);
  
  // Distance slider value
  double _distance = 15.0;
  
  // Dropdown values
  String _selectedGender = 'Men';
  String _selectedRelationshipType = 'Serious Dating';
  String _selectedEducation = 'College+';
  String _selectedLifestyle = 'Active';
  
  // Expandable sections state
  bool _isSocialLinksExpanded = false;
  bool _isDatingPreferencesExpanded = false;
  bool _isInterestsExpanded = false;
  bool _isRedFlagsExpanded = false;
  bool _isLookingForExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  void _initializeUserData() async {
    // Get current cached data immediately
    _userData = _userDatabase.currentUserData;
    if (_userData != null) {
      setState(() {});
    }
    
    // Initialize UserDatabase (this will set up real-time listener)
    await _userDatabase.initializeUserData();
    
    // Listen to user data changes
    _userDataSubscription = _userDatabase.userDataStream.listen((userData) {
      if (mounted) {
        setState(() {
          _userData = userData;
        });
        print('Profile Screen: User data updated - ${userData?.username ?? 'null'}');
      }
    });
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
  }

  Color _getSubscriptionColor(String subscriptionType) {
    switch (subscriptionType.toLowerCase()) {
      case 'premium':
        return Colors.amber;
      case 'elite':
        return Colors.cyan;
      case 'infinity':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getSubscriptionIcon(String subscriptionType) {
    switch (subscriptionType.toLowerCase()) {
      case 'premium':
        return FontAwesomeIcons.crown;
      case 'elite':
        return FontAwesomeIcons.gem;
      case 'infinity':
        return FontAwesomeIcons.infinity;
      default:
        return FontAwesomeIcons.user;
    }
  }

  Widget _buildTokenDisplay({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 2,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppText.profile,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
              const SizedBox(height: 8), // Reduced space since we have AppBar
              
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56),
                          image: DecorationImage(
                            image: //_userData?.profileImageUrls?.isNotEmpty == true
                               // ? NetworkImage(_userData!.profileImageUrls!.first)
                               // : const NetworkImage('https://i.pravatar.cc/300?img=5'),
                            NetworkImage('https://i.pravatar.cc/300?img=5'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _userData?.username ?? 'Loading...',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.circle,
                            size: 8,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Online',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileSection(
                context,
                title: AppText.profile,
                items: [
                  _ProfileItem(label: 'Username', value: _userData?.username ?? 'Loading...'),
                  _ProfileItem(label: 'Age', value: _userData?.age.toString() ?? 'Loading...'),
                  _ProfileItem(label: 'Gender', value: _userData?.gender ?? 'Loading...'),
                  _ProfileItem(label: 'Mobile', value: _userData?.phone ?? 'Not provided'),
                  _ProfileItem(label: 'Nationality', value: _userData?.nationality ?? 'Loading...'),
                ],
              ),
              const SizedBox(height: 8),

              // Dating Preferences Section
              _buildExpandableSection(
                context,
                title: 'Dating Preferences',
                icon: FontAwesomeIcons.heart,
                color: Colors.pink,
                isExpanded: _isDatingPreferencesExpanded,
                onToggle: () => setState(() => _isDatingPreferencesExpanded = !_isDatingPreferencesExpanded),
                content: _buildPreferencesContent(context),
              ),
              const SizedBox(height: 16),
              
              // Interests & Hobbies Section
              _buildExpandableSection(
                context,
                title: 'Interests & Hobbies',
                icon: FontAwesomeIcons.star,
                color: Colors.purple,
                isExpanded: _isInterestsExpanded,
                onToggle: () => setState(() => _isInterestsExpanded = !_isInterestsExpanded),
                content: _buildInterestsContent(context),
              ),
              const SizedBox(height: 16),
              
              // Red Flags Section
              _buildExpandableSection(
                context,
                title: 'Deal Breakers',
                icon: FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
                isExpanded: _isRedFlagsExpanded,
                onToggle: () => setState(() => _isRedFlagsExpanded = !_isRedFlagsExpanded),
                content: _buildRedFlagsContent(context),
              ),
              const SizedBox(height: 16),
              
              // Looking For Section
              _buildExpandableSection(
                context,
                title: 'Looking For',
                icon: FontAwesomeIcons.search,
                color: Colors.amber,
                isExpanded: _isLookingForExpanded,
                onToggle: () => setState(() => _isLookingForExpanded = !_isLookingForExpanded),
                content: _buildLookingForContent(context),
              ),
              const SizedBox(height: 16),
                _buildExpandableSection(
                  context,
                  title: 'Link Social Platforms',
                  icon: FontAwesomeIcons.share,
                  color: Theme.of(context).colorScheme.secondary,
                  isExpanded: _isSocialLinksExpanded,
                  onToggle: () => setState(() => _isSocialLinksExpanded = !_isSocialLinksExpanded),
                  content: _buildSocialLinkContent(context),
                ),
                const SizedBox(height: 16),

                Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.coins,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Wallet Balance',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (_userData?.goldTokens ?? 0).toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (_userData?.silverTokens ?? 0).toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Recharge',
                            icon: FontAwesomeIcons.plus,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  TokensScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            text: 'Withdraw',
                            icon: FontAwesomeIcons.arrowDown,
                            isOutlined: true,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  TokensScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.red,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to leave?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll miss you! You can always come back.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: AppText.logout,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      width: double.infinity,
                      icon: FontAwesomeIcons.arrowRightFromBracket,
                      onPressed: () => _confirmLogout(context),
                       ),
                     ],
                   ),
                 ),
                ],
              )
            )
          )
    ])
    );
  }

  Widget _buildLookingForContent(BuildContext context) {
    final lookingFor = _userData?.lookingFor ?? [];
    
    return _buildSubSection(
      title: 'Looking For',
      icon: FontAwesomeIcons.search,
      color: const Color(0xFFF59E0B),
      items: lookingFor,
      context: context,
    );
  }

  Widget _buildExpandableSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(20),
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
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: content,
              ) : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkContent(BuildContext context) {
    return Column(
      children: [
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.facebook,
          label: 'Facebook',
          color: Colors.blue,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppText.comingSoon)),
            );
          },
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.xTwitter,
          label: 'X',
          color: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppText.comingSoon)),
            );
          },
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.instagram,
          label: 'Instagram',
          color: Colors.pink,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppText.comingSoon)),
            );
          },
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.tiktok,
          label: 'TikTok',
          color: Colors.black,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppText.comingSoon)),
            );

          },
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.whatsapp,
          label: 'WhatsApp',
          color: Colors.green,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppText.comingSoon)),
            );

          },
        ),
      ],
    );
  }

  Widget _buildPreferencesContent(BuildContext context) {
    return Column(
      children: [
        // Age Range Slider
        _buildAgeRangeSlider(context),
        const SizedBox(height: 20),
        
        // Distance Slider
        _buildDistanceSlider(context),
        const SizedBox(height: 16),
        
        // Region Selection
        _buildRegionSelector(context),
        const SizedBox(height: 16),
        
        // Gender Dropdown
        _buildDropdownSelector(
          context,
          'Gender',
          _selectedGender,
          ['Men', 'Women', 'Non-binary', 'Everyone'],
          FontAwesomeIcons.person,
          Colors.indigo,
          (value) => setState(() => _selectedGender = value!),
        ),
        const SizedBox(height: 16),
        
        // Relationship Type Dropdown
        _buildDropdownSelector(
          context,
          'Relationship Type',
          _selectedRelationshipType,
          ['Casual Dating', 'Serious Dating', 'Long-term', 'Marriage', 'Friendship', 'Something Casual'],
          FontAwesomeIcons.heartCircleCheck,
          Colors.pink,
          (value) => setState(() => _selectedRelationshipType = value!),
        ),
        const SizedBox(height: 16),
        
        // Education Dropdown
        _buildDropdownSelector(
          context,
          'Education',
          _selectedEducation,
          ['High School', 'Some College', 'College+', 'Graduate Degree', 'PhD/Doctorate', 'Trade School', 'Other'],
          FontAwesomeIcons.graduationCap,
          Colors.blue,
          (value) => setState(() => _selectedEducation = value!),
        ),
        const SizedBox(height: 16),
        
        // Lifestyle Dropdown
        _buildDropdownSelector(
          context,
          'Lifestyle',
          _selectedLifestyle,
          ['Very Active', 'Active', 'Somewhat Active', 'Not Very Active', 'Varies'],
          FontAwesomeIcons.dumbbell,
          Colors.green,
          (value) => setState(() => _selectedLifestyle = value!),
        ),
      ],
    );
  }

  Widget _buildInterestsContent(BuildContext context) {
    final theme = Theme.of(context);
    final interests = _userData?.interests ?? [];
    final hobbies = _userData?.hobbies ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interests Section
        _buildSubSection(
          title: 'Interests',
          icon: FontAwesomeIcons.heart,
          color: const Color(0xFFEC4899),
          items: interests,
          context: context,
        ),
        const SizedBox(height: 24),
        
        // Hobbies Section
        _buildSubSection(
          title: 'Hobbies',
          icon: FontAwesomeIcons.gamepad,
          color: const Color(0xFF9333EA),
          items: hobbies,
          context: context,
        ),
      ],
    );
  }

  Widget _buildSubSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Items
        if (items.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) => _buildStyledChip(
              context: context,
              label: item,
              color: color,
            )).toList(),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              'No $title added',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRedFlagsContent(BuildContext context) {
    final dealBreakers = _userData?.dealBreakers ?? [];
    
    return _buildSubSection(
      title: 'Deal Breakers',
      icon: FontAwesomeIcons.ban,
      color: const Color(0xFFDC2626),
      items: dealBreakers,
      context: context,
    );
  }

  Widget _buildAgeRangeSlider(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.pink.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.calendar,
                color: Colors.pink,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Age Range',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 65,
            divisions: 47,
            activeColor: Colors.pink,
            inactiveColor: Colors.pink.withOpacity(0.3),
            labels: RangeLabels(
              _ageRange.start.round().toString(),
              _ageRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _ageRange = values;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSlider(BuildContext context) {
    final theme = Theme.of(context);
    String distanceText;
    if (_distance >= 25) {
      distanceText = '25km+';
    } else {
      distanceText = '${_distance.round()}km';
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.locationDot,
                color: Colors.blue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Distance',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  distanceText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(
            value: _distance,
            min: 2,
            max: 25,
            divisions: 23,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.3),
            label: distanceText,
            onChanged: (double value) {
              setState(() {
                _distance = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegionSelector(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.purple.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const FaIcon(
              FontAwesomeIcons.infinity,
              color: Colors.purple,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Region - Infinity',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'New York, United States',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.blue.shade400],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.globe,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Change',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(BuildContext context) {
    final theme = Theme.of(context);
    final interests = [
      'Photography', 'Travel', 'Hiking', 'Cooking', 'Music',
      'Dancing', 'Reading', 'Fitness', 'Art', 'Movies'
    ];
    final hobbies = [
      'Yoga', 'Swimming', 'Gaming', 'Painting', 'Gardening',
      'Writing', 'Cycling', 'Meditation'
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.star,
                  color: Colors.purple,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Interests & Hobbies',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Interests',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) => _buildChip(context, interest, Colors.blue)).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Hobbies',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hobbies.map((hobby) => _buildChip(context, hobby, Colors.green)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRedFlagsSection(BuildContext context) {
    final theme = Theme.of(context);
    final redFlags = [
      'Smoking', 'Excessive Drinking', 'Dishonesty', 'Poor Communication',
      'Lack of Ambition', 'Disrespectful Behavior'
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Deal Breakers',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: redFlags.map((flag) => _buildChip(context, flag, Colors.red)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelector(
    BuildContext context,
    String label,
    String currentValue,
    List<String> options,
    IconData icon,
    Color color,
    void Function(String?) onChanged,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: currentValue,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: 12,
                      color: color,
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                    dropdownColor: theme.cardColor,
                    onChanged: onChanged,
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStyledChip({
    required BuildContext context,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, {
    required String title,
    required List<_ProfileItem> items,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isNotEmpty)
            Column(
              children: items.map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        item.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item.value,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
        ]
      )
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              AppText.logout,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text('Are you sure you want to logout? You will need to sign in again to access your account.'),
        actions: [
          CustomButton(
            text: AppText.cancel,
            isOutlined: true,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          CustomButton(
            text: AppText.logout,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            icon: FontAwesomeIcons.arrowRightFromBracket,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileItem {
  final String label;
  final String value;

  _ProfileItem({required this.label, required this.value});
}

class _SocialPlatformLinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SocialPlatformLinkRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
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
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomButton(
            text: 'Link',
            backgroundColor: color,
            textColor: Colors.white,
            height: 36,
            borderRadius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}