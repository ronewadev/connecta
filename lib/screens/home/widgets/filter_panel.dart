import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final RangeValues ageRange;
  final double distance;
  final String selectedGender;
  final String selectedLocation;
  final List<String> selectedInterests;
  final bool onlineOnly;
  final Function(RangeValues) onAgeRangeChanged;
  final Function(double) onDistanceChanged;
  final Function(String) onGenderChanged;
  final Function(String) onLocationChanged;
  final Function(List<String>) onInterestsChanged;
  final Function(bool) onOnlineOnlyChanged;
  final VoidCallback onReset;

  const FilterPanel({
    Key? key,
    required this.ageRange,
    required this.distance,
    required this.selectedGender,
    required this.selectedLocation,
    required this.selectedInterests,
    required this.onlineOnly,
    required this.onAgeRangeChanged,
    required this.onDistanceChanged,
    required this.onGenderChanged,
    required this.onLocationChanged,
    required this.onInterestsChanged,
    required this.onOnlineOnlyChanged,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onReset,
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Age Range
          Text(
            'Age: ${ageRange.start.round()}-${ageRange.end.round()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          RangeSlider(
            values: ageRange,
            min: 18,
            max: 80,
            divisions: 62,
            onChanged: onAgeRangeChanged,
          ),

          const SizedBox(height: 12),

          // Gender Filter
          Text(
            'Gender',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Everyone', 'Male', 'Female', 'Other'].map((gender) {
              return FilterChip(
                label: Text(gender),
                selected: selectedGender == gender,
                onSelected: (selected) {
                  if (selected) {
                    onGenderChanged(gender);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Distance
          Text(
            'Distance: ${distance.round()} km',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: distance,
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: onDistanceChanged,
          ),

          const SizedBox(height: 8),

          // Online Only Toggle
          CheckboxListTile(
            title: const Text('Online only'),
            subtitle: const Text('Show only active users'),
            value: onlineOnly,
            onChanged: (value) => onOnlineOnlyChanged(value ?? false),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}