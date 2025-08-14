import 'package:flutter/material.dart';
import '../../../services/profile_data_service.dart';

class InterestsFilterContent extends StatefulWidget {
  final ThemeData theme;
  final List<String> selectedInterests;
  final Function(List<String>) onSelectionChanged;


  const InterestsFilterContent({
    Key? key,
    required this.theme,
    required this.selectedInterests,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<InterestsFilterContent> createState() => _InterestsFilterContentState();
}

class _InterestsFilterContentState extends State<InterestsFilterContent> {

  List<String> _interests = [];
  List<String> _hobbies = [];
  List<String> _dealBreakers = [];


  List<String> get _allInterests => [
    ..._interests,
    ..._hobbies,
    ..._dealBreakers,
  ];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final profileData = await ProfileDataService.getAllProfileData();
      setState(() {
        _interests = List<String>.from(profileData['interests'] ?? []);
        _hobbies = List<String>.from(profileData['hobbies'] ?? []);
        _dealBreakers = List<String>.from(profileData['deal_breakers'] ?? []);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onInterestSelected(String interest, bool selected) {
    setState(() {
      if (selected) {
        widget.selectedInterests.add(interest);
      } else {
        widget.selectedInterests.remove(interest);
      }
    });
    widget.onSelectionChanged(widget.selectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Select interests to match',
          style: widget.theme.textTheme.bodyMedium?.copyWith(
            color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _allInterests.map((interest) {
            final isSelected = widget.selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              selectedColor: Colors.green.withOpacity(0.2),
              checkmarkColor: Colors.green,
              onSelected: (selected) => _onInterestSelected(interest, selected),
            );
          }).toList(),
        ),
      ],
    );
  }
}
