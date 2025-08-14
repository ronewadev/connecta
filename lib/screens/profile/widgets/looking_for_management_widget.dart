import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/services/profile_data_service.dart';
import 'package:connecta/services/update_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LookingForManagementWidget extends StatefulWidget {
  final List<String> currentLookingFor;
  final VoidCallback? onUpdate;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  const LookingForManagementWidget({
    super.key,
    required this.currentLookingFor,
    this.onUpdate,
    this.isExpanded = false,
    this.onToggleExpanded,
  });

  @override
  State<LookingForManagementWidget> createState() => _LookingForManagementWidgetState();
}

class _LookingForManagementWidgetState extends State<LookingForManagementWidget> 
    with TickerProviderStateMixin {
  
  bool _isEditing = false;
  Map<String, Set<String>> _selectedByCategory = {};
  Map<String, List<String>> _lookingForCategories = {};
  bool _isLoading = true;
  bool _isUpdating = false;
  
  // Different max selections per category
  final Map<String, int> _maxPerCategory = {
    'Relationship Type': 2,
    'Personality': 4,
    'Lifestyle': 4,
    'Values': 4,
  };

  final Map<String, IconData> _categoryIcons = {
    'Relationship Type': FontAwesomeIcons.heart,
    'Personality': FontAwesomeIcons.user,
    'Lifestyle': FontAwesomeIcons.leaf,
    'Values': FontAwesomeIcons.star,
  };

  final Map<String, Color> _categoryColors = {
    'Relationship Type': const Color(0xFFEC4899),
    'Personality': const Color(0xFF9333EA),
    'Lifestyle': const Color(0xFF06B6D4),
    'Values': const Color(0xFF10B981),
  };

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
    // Initialize selected items from current user data
    _selectedByCategory = {
      'Relationship Type': <String>{},
      'Personality': <String>{},
      'Lifestyle': <String>{},
      'Values': <String>{},
    };

    _loadCurrentSelections();
    _loadProfileData();
  }

  void _loadCurrentSelections() {
    // Categorize current looking for items
    for (String item in widget.currentLookingFor) {
      bool found = false;
      for (String category in _selectedByCategory.keys) {
        final categoryItems = _lookingForCategories[category] ?? [];
        if (categoryItems.contains(item)) {
          _selectedByCategory[category]?.add(item);
          found = true;
          break;
        }
      }
      
      // If item not found in any category, try to match by common terms
      if (!found) {
        if (_isRelationshipType(item)) {
          _selectedByCategory['Relationship Type']?.add(item);
        } else if (_isPersonalityTrait(item)) {
          _selectedByCategory['Personality']?.add(item);
        } else if (_isLifestyleTrait(item)) {
          _selectedByCategory['Lifestyle']?.add(item);
        } else if (_isValueTrait(item)) {
          _selectedByCategory['Values']?.add(item);
        }
      }
    }
  }

  bool _isRelationshipType(String item) {
    final relationshipTerms = ['relationship', 'dating', 'casual', 'serious', 'marriage', 'long-term', 'short-term'];
    return relationshipTerms.any((term) => item.toLowerCase().contains(term));
  }

  bool _isPersonalityTrait(String item) {
    final personalityTerms = ['funny', 'serious', 'adventurous', 'calm', 'outgoing', 'introvert', 'creative', 'logical'];
    return personalityTerms.any((term) => item.toLowerCase().contains(term));
  }

  bool _isLifestyleTrait(String item) {
    final lifestyleTerms = ['active', 'fitness', 'travel', 'home', 'party', 'quiet', 'outdoor', 'indoor'];
    return lifestyleTerms.any((term) => item.toLowerCase().contains(term));
  }

  bool _isValueTrait(String item) {
    final valueTerms = ['honest', 'loyal', 'family', 'career', 'spiritual', 'ambitious', 'kind', 'respect'];
    return valueTerms.any((term) => item.toLowerCase().contains(term));
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
          final lookingFor = List<String>.from(data['lookingFor'] ?? []);
          if (lookingFor.toString() != widget.currentLookingFor.toString()) {
            setState(() {
              _loadCurrentSelections();
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
          _lookingForCategories = {
            'Relationship Type': profileData['relationship_types'] ?? [],
            'Personality': profileData['personality'] ?? [],
            'Lifestyle': profileData['lifestyle'] ?? [],
            'Values': profileData['values'] ?? [],
          };
          _isLoading = false;
        });
        
        // Re-load current selections after categories are loaded
        _loadCurrentSelections();
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
  void didUpdateWidget(LookingForManagementWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    
    if (widget.currentLookingFor != oldWidget.currentLookingFor) {
      _loadCurrentSelections();
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
                          const Color(0xFF9333EA).withOpacity(0.8),
                          const Color(0xFF9333EA).withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9333EA).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.searchengin,
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
                          'Looking For',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_getTotalSelected()} preferences selected',
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
                          onTap: _isUpdating ? null : _saveLookingFor,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getTotalSelected() >= 3
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
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : FaIcon(
                                    FontAwesomeIcons.check,
                                    color: _getTotalSelected() >= 3
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF9333EA).withOpacity(0.3),
                              const Color(0xFF9333EA).withOpacity(0.2),
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
    if (widget.currentLookingFor.isEmpty) {
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
              FontAwesomeIcons.searchengin,
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
              'Tap Edit to add your dating preferences',
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.currentLookingFor.map((item) {
            final category = _getCategoryForItem(item);
            final color = _categoryColors[category] ?? const Color(0xFF9333EA);
            
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

  String _getCategoryForItem(String item) {
    for (String category in _lookingForCategories.keys) {
      if (_lookingForCategories[category]?.contains(item) ?? false) {
        return category;
      }
    }
    return 'Relationship Type'; // Default
  }

  Widget _buildEditingInterface() {
    return Column(
      children: [
        // Selection requirement info
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
                  'Select at least 3 preferences. Choose ${_getTotalSelected()}/14 total',
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
        
        // Categories
        ..._lookingForCategories.entries.map((entry) {
          return Column(
            children: [
              _buildCategorySection(
                title: entry.key,
                items: entry.value,
                icon: _categoryIcons[entry.key]!,
                color: _categoryColors[entry.key]!,
                maxSelection: _maxPerCategory[entry.key]!,
              ),
              const SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
    required int maxSelection,
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
                      '${_selectedByCategory[title]?.length ?? 0}/$maxSelection selected',
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
              final isSelected = _selectedByCategory[title]?.contains(item) ?? false;
              final canSelect = (_selectedByCategory[title]?.length ?? 0) < maxSelection;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedByCategory[title]?.remove(item);
                    } else if (canSelect) {
                      _selectedByCategory[title]?.add(item);
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
                              Colors.white.withOpacity(canSelect ? 0.2 : 0.1),
                              Colors.white.withOpacity(canSelect ? 0.1 : 0.05),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? color.withOpacity(0.8)
                          : Colors.white.withOpacity(canSelect ? 0.3 : 0.15),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Colors.white.withOpacity(canSelect || isSelected ? 1.0 : 0.5),
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  int _getTotalSelected() {
    return _selectedByCategory.values.fold(0, (sum, set) => sum + set.length);
  }

  List<String> _getAllSelected() {
    return _selectedByCategory.values.expand((set) => set).toList();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      // Reset selections to current user data
      _loadCurrentSelections();
    });
  }

  Future<void> _saveLookingFor() async {
    if (_getTotalSelected() < 3) {
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
              Text('Please select at least 3 preferences'),
            ],
          ),
          backgroundColor: const Color(0xFFEC4899),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final selectedItems = _getAllSelected();
      final success = await ProfileUpdateService.updateLookingFor(selectedItems as Map<String, List<String>>);
      
      if (success && mounted) {
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
                Text('Looking for preferences updated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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