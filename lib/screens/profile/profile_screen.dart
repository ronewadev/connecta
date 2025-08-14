// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connecta/models/user_model.dart' as UserModel;
import 'package:connecta/screens/auth/welcome_screen.dart';
import 'package:connecta/screens/plans/tokens_screen.dart';
import 'package:connecta/screens/profile/widgets/bio_section_widget.dart';
import 'package:connecta/screens/profile/widgets/images_section_widget.dart';
import 'package:connecta/services/profile_data_service.dart';
import 'package:connecta/utils/text_strings.dart';
import 'package:connecta/widgets/custom_button.dart' hide IconButton;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/update_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel.UserModelInfo? _userData;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

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

  // Edit mode states
  bool _isEditingInterests = false;
  bool _isEditingHobbies = false;
  bool _isEditingDealBreakers = false;
  // Bio editing
  late TextEditingController _bioController;


  // Dynamic data from Firestore
  Map<String, List<String>> _profileData = {};
  bool _isLoadingProfileData = true;

  // Temporary edit lists
  List<String> _tempInterests = [];
  List<String> _tempHobbies = [];
  List<String> _tempDealBreakers = [];
  Map<String, List<String>> _tempLookingFor = {
    'Personality': [],
    'Values': [],
    'Lifestyle': [],
    'Relationship Type': []
  };

  // Social media status
  Map<String, bool> _socialMediaStatus = {
    'facebook': false,
    'instagram': false,
    'x': false,
    'tiktok': false,
    'whatsapp': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _loadProfileData();
  }

  void _initializeUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Set up real-time listener for current user
      _userSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          setState(() {
            _userData = UserModel.UserModelInfo.fromMap(snapshot.data()!, user.uid);
            _loadSocialMediaStatus();
          });
        }
      });
    }
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileDataService.getAllProfileData();
      setState(() {
        _profileData = profileData;
        _isLoadingProfileData = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        _isLoadingProfileData = false;
      });
    }
  }

  void _loadSocialMediaStatus() {
    if (_userData != null) {
      final data = _userData!.toMap();
      _socialMediaStatus = {
        'facebook': data['socialMedia']?['facebook']?['isLinked'] ?? false,
        'instagram': data['socialMedia']?['instagram']?['isLinked'] ?? false,
        'x': data['socialMedia']?['x']?['isLinked'] ?? false,
        'tiktok': data['socialMedia']?['tiktok']?['isLinked'] ?? false,
        'whatsapp': data['socialMedia']?['whatsapp']?['isLinked'] ?? false,
      };
    }
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
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
      body: _userData == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            )
          : CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 8),
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
                                image: (_userData!.profileImageUrl != null)
                                    ? DecorationImage(
                                  image: NetworkImage(_userData!.profileImageUrl!),
                                  fit: BoxFit.cover,
                                )
                                    : (_userData!.profileImages.isNotEmpty)
                                        ? DecorationImage(
                                      image: NetworkImage(_userData!.profileImages.first),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                              ),
                              child: (_userData!.profileImageUrl == null && _userData!.profileImages.isEmpty)
                                  ? Center(
                                child: FaIcon(
                                  FontAwesomeIcons.user,
                                  color: Colors.white70,
                                  size: 56,
                                ),
                              )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _userData!.username,
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
                        _ProfileItem(label: 'Username', value: _userData!.username),
                        _ProfileItem(label: 'Age', value: _userData!.age.toString()),
                        _ProfileItem(label: 'Gender', value: _userData!.gender),
                        _ProfileItem(label: 'Mobile', value: _userData!.phone ?? 'Not provided'),
                        _ProfileItem(label: 'Nationality', value: _userData!.nationality),
                        _ProfileItem(label: 'Current City', value: _userData!.currentCity ?? 'Not provided'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BioSectionWidget(
                      bio: _userData!.bio,
                      onBioUpdated: () {
                        // Refresh user data after bio update
                        setState(() {
                          // The user data will be automatically updated through the stream
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ImagesSectionWidget(
                      profileImages: _userData!.profileImages,
                      onImagesUpdated: () {
                        // Refresh user data after images update
                        setState(() {
                          // The user data will be automatically updated through the stream
                        });
                      },
                    ),
                    const SizedBox(height: 8),
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
                                      _userData!.goldTokens.toString(),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade500,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _userData!.silverTokens.toString(),
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
                                        builder: (context) => TokensScreen(),
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
                                        builder: (context) => TokensScreen(),
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
                  ]),
                ),
              ),
            ],
            )
          );
  }

  Widget _buildLookingForContent(BuildContext context) {
    return _buildSubSection(
      title: 'Looking For',
      icon: FontAwesomeIcons.search,
      color: const Color(0xFFF59E0B),
      items: _userData!.hobbies,
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
          isLinked: _socialMediaStatus['facebook'] ?? false,
          onPressed: () => _handleSocialMediaToggle('facebook'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.xTwitter,
          label: 'X',
          color: Colors.black,
          isLinked: _socialMediaStatus['x'] ?? false,
          onPressed: () => _handleSocialMediaToggle('x'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.instagram,
          label: 'Instagram',
          color: Colors.pink,
          isLinked: _socialMediaStatus['instagram'] ?? false,
          onPressed: () => _handleSocialMediaToggle('instagram'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.tiktok,
          label: 'TikTok',
          color: Colors.black,
          isLinked: _socialMediaStatus['tiktok'] ?? false,
          onPressed: () => _handleSocialMediaToggle('tiktok'),
        ),
        _SocialPlatformLinkRow(
          icon: FontAwesomeIcons.whatsapp,
          label: 'WhatsApp',
          color: Colors.green,
          isLinked: _socialMediaStatus['whatsapp'] ?? false,
          onPressed: () => _handleSocialMediaToggle('whatsapp'),
        ),
      ],
    );
  }

  void _handleSocialMediaToggle(String platform) {
    final isCurrentlyLinked = _socialMediaStatus[platform] ?? false;

    if (isCurrentlyLinked) {
      // Unlink
      _showUnlinkConfirmDialog(platform);
    } else {
      // Link
      _showLinkDialog(platform);
    }
  }

  void _showLinkDialog(String platform) {
    final controller = TextEditingController();
    String hint = '';
    String example = '';

    switch (platform) {
      case 'facebook':
        hint = 'Enter your Facebook profile URL';
        example = 'facebook.com/username';
        break;
      case 'instagram':
        hint = 'Enter your Instagram username';
        example = '@username';
        break;
      case 'x':
        hint = 'Enter your X (Twitter) handle';
        example = '@username';
        break;
      case 'tiktok':
        hint = 'Enter your TikTok username';
        example = '@username';
        break;
      case 'whatsapp':
        hint = 'Enter your WhatsApp number';
        example = '+1234567890';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            FaIcon(_getPlatformIcon(platform), color: _getPlatformColor(platform), size: 24),
            const SizedBox(width: 12),
            Text('Link ${platform.toUpperCase()}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                labelText: example,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final link = controller.text.trim();
              if (link.isNotEmpty) {
                final success = await ProfileUpdateService.updateSocialMediaLink(
                  platform,
                  isLinked: true,
                  link: link,
                );

                if (success) {
                  setState(() {
                    _socialMediaStatus[platform] = true;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${platform.toUpperCase()} linked successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to link ${platform.toUpperCase()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Link'),
          ),
        ],
      ),
    );
  }

  void _showUnlinkConfirmDialog(String platform) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.unlink, color: Colors.red, size: 24),
            const SizedBox(width: 12),
            Text('Unlink ${platform.toUpperCase()}'),
          ],
        ),
        content: Text('Are you sure you want to unlink your ${platform.toUpperCase()} account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await ProfileUpdateService.updateSocialMediaLink(
                platform,
                isLinked: false,
              );

              if (success) {
                setState(() {
                  _socialMediaStatus[platform] = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${platform.toUpperCase()} unlinked successfully!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to unlink ${platform.toUpperCase()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unlink', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'facebook': return FontAwesomeIcons.facebook;
      case 'instagram': return FontAwesomeIcons.instagram;
      case 'x': return FontAwesomeIcons.xTwitter;
      case 'tiktok': return FontAwesomeIcons.tiktok;
      case 'whatsapp': return FontAwesomeIcons.whatsapp;
      default: return FontAwesomeIcons.link;
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'facebook': return Colors.blue;
      case 'instagram': return Colors.pink;
      case 'x': return Colors.black;
      case 'tiktok': return Colors.black;
      case 'whatsapp': return Colors.green;
      default: return Colors.grey;
    }
  }

  // Edit helper methods for interests
  void _startEditingInterests() {
    setState(() {
      _isEditingInterests = true;
      _tempInterests = List.from(_userData!.interests);
    });
  }

  void _cancelEditingInterests() {
    setState(() {
      _isEditingInterests = false;
      _tempInterests.clear();
    });
  }

  void _addTempInterest(String interest) {
    if (!_tempInterests.contains(interest) && _tempInterests.length < 5) {
      setState(() {
        _tempInterests.add(interest);
      });
    }
  }

  void _removeTempInterest(String interest) {
    setState(() {
      _tempInterests.remove(interest);
    });
  }

  Future<void> _saveInterests() async {
    final success = await ProfileUpdateService.updateInterests(_tempInterests);
    if (success) {
      setState(() {
        _isEditingInterests = false;
        _tempInterests.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interests updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update interests'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Edit helper methods for hobbies
  void _startEditingHobbies() {
    setState(() {
      _isEditingHobbies = true;
      _tempHobbies = List.from(_userData!.hobbies);
    });
  }

  void _cancelEditingHobbies() {
    setState(() {
      _isEditingHobbies = false;
      _tempHobbies.clear();
    });
  }

  void _addTempHobby(String hobby) {
    if (!_tempHobbies.contains(hobby) && _tempHobbies.length < 5) {
      setState(() {
        _tempHobbies.add(hobby);
      });
    }
  }

  void _removeTempHobby(String hobby) {
    setState(() {
      _tempHobbies.remove(hobby);
    });
  }

  Future<void> _saveHobbies() async {
    final success = await ProfileUpdateService.updateHobbies(_tempHobbies);
    if (success) {
      setState(() {
        _isEditingHobbies = false;
        _tempHobbies.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hobbies updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update hobbies'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Edit helper methods for deal breakers
  void _startEditingDealBreakers() {
    setState(() {
      _isEditingDealBreakers = true;
      _tempDealBreakers = List.from(_userData!.dealBreakers);
    });
  }

  void _cancelEditingDealBreakers() {
    setState(() {
      _isEditingDealBreakers = false;
      _tempDealBreakers.clear();
    });
  }

  void _addTempDealBreaker(String dealBreaker) {
    if (!_tempDealBreakers.contains(dealBreaker) && _tempDealBreakers.length < 5) {
      setState(() {
        _tempDealBreakers.add(dealBreaker);
      });
    }
  }

  void _removeTempDealBreaker(String dealBreaker) {
    setState(() {
      _tempDealBreakers.remove(dealBreaker);
    });
  }

  Future<void> _saveDealBreakers() async {
    final success = await ProfileUpdateService.updateDealBreakers(_tempDealBreakers);
    if (success) {
      setState(() {
        _isEditingDealBreakers = false;
        _tempDealBreakers.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deal breakers updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update deal breakers'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interests Section
        _buildEditableSubSection(
          title: 'Interests',
          icon: FontAwesomeIcons.heart,
          color: const Color(0xFFEC4899),
          items: _userData!.interests,
          isEditing: _isEditingInterests,
          tempItems: _tempInterests,
          maxItems: 5,
          context: context,
          onEdit: () => _startEditingInterests(),
          onSave: () => _saveInterests(),
          onCancel: () => _cancelEditingInterests(),
          onAdd: (item) => _addTempInterest(item),
          onRemove: (item) => _removeTempInterest(item),
        ),
        const SizedBox(height: 24),

        // Hobbies Section
        _buildEditableSubSection(
          title: 'Hobbies',
          icon: FontAwesomeIcons.gamepad,
          color: const Color(0xFF9333EA),
          items: _userData!.hobbies,
          isEditing: _isEditingHobbies,
          tempItems: _tempHobbies,
          maxItems: 5,
          context: context,
          onEdit: () => _startEditingHobbies(),
          onSave: () => _saveHobbies(),
          onCancel: () => _cancelEditingHobbies(),
          onAdd: (item) => _addTempHobby(item),
          onRemove: (item) => _removeTempHobby(item),
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
    return _buildEditableSubSection(
      title: 'Deal Breakers',
      icon: FontAwesomeIcons.ban,
      color: const Color(0xFFDC2626),
      items: _userData!.dealBreakers,
      isEditing: _isEditingDealBreakers,
      tempItems: _tempDealBreakers,
      maxItems: 5,
      context: context,
      onEdit: () => _startEditingDealBreakers(),
      onSave: () => _saveDealBreakers(),
      onCancel: () => _cancelEditingDealBreakers(),
      onAdd: (item) => _addTempDealBreaker(item),
      onRemove: (item) => _removeTempDealBreaker(item),
    );
  }

  Widget _buildEditableSubSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
    required bool isEditing,
    required List<String> tempItems,
    required int maxItems,
    required BuildContext context,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    required Function(String) onAdd,
    required Function(String) onRemove,
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
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(24),
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
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (!isEditing)
              IconButton(
                onPressed: onEdit,
                icon: const FaIcon(
                  FontAwesomeIcons.penToSquare,
                  size: 16,
                ),
                color: color,
              ),
          ],
        ),
        const SizedBox(height: 16),

        if (isEditing) ...[
          // Edit mode
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Edit $title (${tempItems.length}/$maxItems)',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(backgroundColor: color),
                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Show available options from Firestore
                if (_profileData.isNotEmpty && !_isLoadingProfileData)
                  _buildEditGrid(
                    availableItems: _profileData[title.toLowerCase()] ??
                                   _profileData[title.toLowerCase().replaceAll(' ', '_')] ??
                                   _profileData['deal_breakers'] ?? [],
                    selectedItems: tempItems,
                    color: color,
                    maxItems: maxItems,
                    onAdd: onAdd,
                    onRemove: onRemove,
                  )
                else
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ] else ...[
          // View mode
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
      ],
    );
  }

  Widget _buildEditGrid({
    required List<String> availableItems,
    required List<String> selectedItems,
    required Color color,
    required int maxItems,
    required Function(String) onAdd,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedItems.isNotEmpty) ...[
          const Text('Selected:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedItems.map((item) => Chip(
              label: Text(item),
              backgroundColor: color.withOpacity(0.2),
              deleteIcon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
              onDeleted: () => onRemove(item),
            )).toList(),
          ),
          const SizedBox(height: 16),
        ],

        if (selectedItems.length < maxItems) ...[
          const Text('Available:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableItems
                .where((item) => !selectedItems.contains(item))
                .map((item) => ActionChip(
                  label: Text(item),
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  onPressed: selectedItems.length < maxItems ? () => onAdd(item) : null,
                ))
                .toList(),
          ),
        ] else
          Text(
            'Maximum $maxItems items selected',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Set rememberMe to false in Firestore before logging out
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({'rememberMe': false});
              }
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
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
  final bool isLinked;

  const _SocialPlatformLinkRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isLinked,
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
          color: isLinked ? Colors.green.withOpacity(0.3) : color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isLinked ? Colors.green : color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              icon,
              color: isLinked ? Colors.green : color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isLinked)
                  Text(
                    'Connected',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          CustomButton(
            text: isLinked ? 'Unlink' : 'Link',
            backgroundColor: isLinked ? Colors.red : color,
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