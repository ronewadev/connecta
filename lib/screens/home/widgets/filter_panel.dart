import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FiltersPanel extends StatefulWidget {
  final Function({
  required RangeValues ageRange,
  required double distance,
  required String gender,
  required String location,
  required bool onlineOnly,
  required List<String> interests,
  }) onFiltersChanged;

  const FiltersPanel({Key? key, required this.onFiltersChanged}) : super(key: key);

  @override
  State<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  RangeValues _ageRange = const RangeValues(18, 35);
  double _distance = 20;
  String _selectedGender = 'Everyone';
  String _selectedLocation = 'All Locations';
  bool _onlineOnly = false;
  List<String> _selectedInterests = [];

  bool _isAgeFilterExpanded = true;
  bool _isLocationFilterExpanded = false;
  bool _isPreferencesFilterExpanded = false;
  bool _isInterestsFilterExpanded = false;

  void _applyFilters() {
    widget.onFiltersChanged(
      ageRange: _ageRange,
      distance: _distance,
      gender: _selectedGender,
      location: _selectedLocation,
      onlineOnly: _onlineOnly,
      interests: _selectedInterests,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
            _buildExpandableFilterSection(
              theme,
              title: 'Interests',
              icon: FontAwesomeIcons.star,
              color: Colors.green,
              isExpanded: _isInterestsFilterExpanded,
              onToggle: () => setState(() => _isInterestsFilterExpanded = !_isInterestsFilterExpanded),
              content: _buildInterestsContent(theme),
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
                    child: FaIcon(icon, color: color, size: 16),
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
                    child: FaIcon(FontAwesomeIcons.chevronDown, color: color, size: 16),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isExpanded ? 1.0 : 0.0,
              child: isExpanded
                  ? Container(
                padding: const EdgeInsets.all(16),
                child: content,
              )
                  : const SizedBox(),
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
    final allLocations = [
      'All Locations',
      'New York',
      'Toronto',
      'Barcelona',
      'Sydney',
      'London'
    ];
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
              .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
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
              .map((location) => DropdownMenuItem(value: location, child: Text(location)))
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
    return SwitchListTile(
      title: const Text('Online Only'),
      subtitle: const Text('Show only users currently online'),
      value: _onlineOnly,
      activeColor: Colors.purple,
      onChanged: (value) {
        setState(() => _onlineOnly = value);
        _applyFilters();
      },
    );
  }

  Widget _buildInterestsContent(ThemeData theme) {
    final allInterests = ['Music', 'Sports', 'Travel', 'Cooking', 'Reading', 'Gaming'];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allInterests.map((interest) {
        final isSelected = _selectedInterests.contains(interest);
        return ChoiceChip(
          label: Text(interest),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedInterests.add(interest);
              } else {
                _selectedInterests.remove(interest);
              }
              _applyFilters();
            });
          },
        );
      }).toList(),
    );
  }
}
