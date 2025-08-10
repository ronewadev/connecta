import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/services/profile_data_service.dart';
import 'package:connecta/functions/update_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestsManagementWidget extends StatefulWidget {
  final List<String> currentInterests;
  final List<String> currentHobbies;
  final List<String> currentDealBreakers;
  final VoidCallback? onUpdate;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  const InterestsManagementWidget({
    super.key,
    required this.currentInterests,
    required this.currentHobbies,
    required this.currentDealBreakers,
    this.onUpdate,
    this.isExpanded = false,
    this.onToggleExpanded,
  });

  @override
  State<InterestsManagementWidget> createState() => _InterestsManagementWidgetState();
}

class _InterestsManagementWidgetState extends State<InterestsManagementWidget> 
    with TickerProviderStateMixin {

  bool _isEditing = false;

  // Selected items during editing
  Set<String> _selectedInterests = {};
  Set<String> _selectedHobbies = {};
  Set<String> _selectedDealBreakers = {};

  // Available items from Firestore
  List<String> _interests = [];
  List<String> _hobbies = [];
  List<String> _dealBreakers = [];

  bool _isLoading = true;
  bool _isUpdating = false;

  // Selection constraints
  final int _minInterests = 2;
  final int _maxInterests = 5;
  final int _minHobbies = 2;
  final int _maxHobbies = 5;
  final int _minDealBreakers = 2;
  final int _maxDealBreakers = 3;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeData();
    _setupRealtimeListener();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    if (widget.isExpanded) {
      _animationController.forward();
    }
  }

  void _initializeData() {
    _selectedInterests = Set.from(widget.currentInterests);
    _selectedHobbies = Set.from(widget.currentHobbies);
    _selectedDealBreakers = Set.from(widget.currentDealBreakers);

    _loadProfileData();
  }

  void _setupRealtimeListener() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userStreamSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && mounted) {
          final data = snapshot.data() as Map<String, dynamic>;

          final interests = List<String>.from(data['interests'] ?? []);
          final hobbies = List<String>.from(data['hobbies'] ?? []);
          final dealBreakers = List<String>.from(data['dealBreakers'] ?? []);

          // Update if data has changed
          if (interests.toString() != widget.currentInterests.toString() ||
              hobbies.toString() != widget.currentHobbies.toString() ||
              dealBreakers.toString() !=
                  widget.currentDealBreakers.toString()) {
            setState(() {
              _selectedInterests = Set.from(interests);
              _selectedHobbies = Set.from(hobbies);
              _selectedDealBreakers = Set.from(dealBreakers);
            });
          }
        }
      });
    }
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileDataService.getAllProfileData();
      if (mounted) {
        setState(() {
          _interests = profileData['interests'] ?? [];
          _hobbies = profileData['hobbies'] ?? [];
          _dealBreakers = profileData['deal_breakers'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(InterestsManagementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    // Update selected items if props changed
    if (widget.currentInterests != oldWidget.currentInterests ||
        widget.currentHobbies != oldWidget.currentHobbies ||
        widget.currentDealBreakers != oldWidget.currentDealBreakers) {
      setState(() {
        _selectedInterests = Set.from(widget.currentInterests);
        _selectedHobbies = Set.from(widget.currentHobbies);
        _selectedDealBreakers = Set.from(widget.currentDealBreakers);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: widget.onToggleExpanded,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFEC4899).withOpacity(0.8),
                          const Color(0xFFEC4899).withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEC4899).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Interests & Preferences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.currentInterests
                              .length} interests • ${widget.currentHobbies
                              .length} hobbies • ${widget.currentDealBreakers
                              .length} deal breakers',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isEditing)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: _cancelEditing,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.xmark,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _isUpdating ? null : _saveChanges,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _canSave()
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _isUpdating
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                                : FaIcon(
                              FontAwesomeIcons.check,
                              color: _canSave()
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _startEditing,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFEC4899).withOpacity(0.3),
                              const Color(0xFFEC4899).withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable Content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: widget.isExpanded
                ? FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: _isLoading
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
                    : Column(
                  children: [
                    if (!_isEditing)
                      _buildCurrentSelections()
                    else
                      _buildEditingInterface(),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSelections() {
    if (widget.currentInterests.isEmpty &&
        widget.currentHobbies.isEmpty &&
        widget.currentDealBreakers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.heart,
              color: Colors.white.withOpacity(0.6),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              'No preferences set',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap Edit to add your interests and preferences',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.currentInterests.isNotEmpty) ...[
          _buildCurrentSection(
            title: 'Interests',
            items: widget.currentInterests,
            color: const Color(0xFFEC4899),
            icon: FontAwesomeIcons.heart,
          ),
          const SizedBox(height: 16),
        ],
        if (widget.currentHobbies.isNotEmpty) ...[
          _buildCurrentSection(
            title: 'Hobbies',
            items: widget.currentHobbies,
            color: const Color(0xFF9333EA),
            icon: FontAwesomeIcons.gamepad,
          ),
          const SizedBox(height: 16),
        ],
        if (widget.currentDealBreakers.isNotEmpty) ...[
          _buildCurrentSection(
            title: 'Deal Breakers',
            items: widget.currentDealBreakers,
            color: const Color(0xFFDC2626),
            icon: FontAwesomeIcons.ban,
          ),
        ],
      ],
    );
  }

  Widget _buildCurrentSection({
    required String title,
    required List<String> items,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              icon,
              color: color.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEditingInterface() {
    return Column(
      children: [
        // Requirements info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF06B6D4).withOpacity(0.3),
                const Color(0xFF06B6D4).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.lightbulb,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select at least 2-5 interests, 2-5 hobbies, and 2-3 deal breakers',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Interests Section
        _buildEditSection(
          title: 'Interests',
          subtitle: 'Select 2-5 interests',
          icon: FontAwesomeIcons.heart,
          items: _interests,
          selectedItems: _selectedInterests,
          minSelection: _minInterests,
          maxSelection: _maxInterests,
          color: const Color(0xFFEC4899),
        ),
        const SizedBox(height: 20),

        // Hobbies Section
        _buildEditSection(
          title: 'Hobbies',
          subtitle: 'Select 2-5 hobbies',
          icon: FontAwesomeIcons.gamepad,
          items: _hobbies,
          selectedItems: _selectedHobbies,
          minSelection: _minHobbies,
          maxSelection: _maxHobbies,
          color: const Color(0xFF9333EA),
        ),
        const SizedBox(height: 20),

        // Deal Breakers Section
        _buildEditSection(
          title: 'Deal Breakers',
          subtitle: 'Select 2-3 deal breakers',
          icon: FontAwesomeIcons.ban,
          items: _dealBreakers,
          selectedItems: _selectedDealBreakers,
          minSelection: _minDealBreakers,
          maxSelection: _maxDealBreakers,
          color: const Color(0xFFDC2626),
        ),
      ],
    );
  }

  Widget _buildEditSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> items,
    required Set<String> selectedItems,
    required int minSelection,
    required int maxSelection,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$subtitle (${selectedItems.length}/$maxSelection)',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Items Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final isSelected = selectedItems.contains(item);
              final canSelect = selectedItems.length < maxSelection;
              final disable = !isSelected && !canSelect;

              return GestureDetector(
                onTap: disable
                    ? null
                    : () {
                  setState(() {
                    if (isSelected) {
                      selectedItems.remove(item);
                    } else if (canSelect) {
                      selectedItems.add(item);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [
                        color.withOpacity(0.8),
                        color.withOpacity(0.6),
                      ],
                    )
                        : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(disable ? 0.1 : 0.2),
                        Colors.white.withOpacity(disable ? 0.05 : 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? color.withOpacity(0.8)
                          : Colors.white.withOpacity(disable ? 0.15 : 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Colors.white.withOpacity(disable ? 0.5 : 1.0),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight
                          .w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _canSave() {
    return _selectedInterests.length >= _minInterests &&
        _selectedInterests.length <= _maxInterests &&
        _selectedHobbies.length >= _minHobbies &&
        _selectedHobbies.length <= _maxHobbies &&
        _selectedDealBreakers.length >= _minDealBreakers &&
        _selectedDealBreakers.length <= _maxDealBreakers;
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      // Reset to current user data
      _selectedInterests = Set.from(widget.currentInterests);
      _selectedHobbies = Set.from(widget.currentHobbies);
      _selectedDealBreakers = Set.from(widget.currentDealBreakers);
    });
  }

  Future<void> _saveChanges() async {
    if (!_canSave()) {
      String message = 'Please ensure:\n';
      if (_selectedInterests.length < _minInterests) {
        message += '• Select at least $_minInterests interests\n';
      }
      if (_selectedHobbies.length < _minHobbies) {
        message += '• Select at least $_minHobbies hobbies\n';
      }
      if (_selectedDealBreakers.length < _minDealBreakers) {
        message += '• Select at least $_minDealBreakers deal breakers';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.exclamationTriangle,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: const Color(0xFFEC4899),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      // Update all three simultaneously
      final results = await Future.wait([
        ProfileUpdateService.updateInterests(_selectedInterests.toList()),
        ProfileUpdateService.updateHobbies(_selectedHobbies.toList()),
        ProfileUpdateService.updateDealBreakers(_selectedDealBreakers.toList()),
      ]);

      final allSuccess = results.every((result) => result);

      if (allSuccess && mounted) {
        setState(() {
          _isEditing = false;
          _isUpdating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Interests and preferences updated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );

        // Call the callback to refresh parent widget
        widget.onUpdate?.call();
      } else if (mounted) {
        setState(() {
          _isUpdating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Failed to update preferences. Please try again.'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.exclamationTriangle,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _userStreamSubscription?.cancel();
    super.dispose();
  }
}