import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PreferencesBuilder {
  final RangeValues ageRange;
  final double distance;
  final String region;
  final String selectedGender;
  final String selectedRelationshipType;
  final String selectedEducation;
  final String selectedLifestyle;
  final ValueChanged<RangeValues>? onAgeRangeChanged;
  final ValueChanged<double>? onDistanceChanged;
  final VoidCallback? onRegionChanged;
  final ValueChanged<String?>? onGenderChanged;
  final ValueChanged<String?>? onRelationshipTypeChanged;
  final ValueChanged<String?>? onEducationChanged;
  final ValueChanged<String?>? onLifestyleChanged;

  const PreferencesBuilder({
    this.ageRange = const RangeValues(18, 30),
    this.distance = 10,
    this.region = 'New York, United States',
    this.selectedGender = 'Everyone',
    this.selectedRelationshipType = 'Serious Dating',
    this.selectedEducation = 'College+',
    this.selectedLifestyle = 'Active',
    this.onAgeRangeChanged,
    this.onDistanceChanged,
    this.onRegionChanged,
    this.onGenderChanged,
    this.onRelationshipTypeChanged,
    this.onEducationChanged,
    this.onLifestyleChanged,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAgeRangeSlider(context),
        const SizedBox(height: 20),
        _buildDistanceSlider(context),
        const SizedBox(height: 16),
        _buildRegionSelector(context),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          context,
          'Gender',
          selectedGender,
          const ['Men', 'Women', 'Non-binary', 'Everyone'],
          FontAwesomeIcons.person,
          Colors.indigo,
          onGenderChanged,
        ),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          context,
          'Relationship Type',
          selectedRelationshipType,
          const ['Casual Dating', 'Serious Dating', 'Long-term', 'Marriage', 'Friendship'],
          FontAwesomeIcons.heartCircleCheck,
          Colors.pink,
          onRelationshipTypeChanged,
        ),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          context,
          'Education',
          selectedEducation,
          const ['High School', 'Some College', 'College+', 'Graduate Degree', 'PhD/Doctorate'],
          FontAwesomeIcons.graduationCap,
          Colors.blue,
          onEducationChanged,
        ),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          context,
          'Lifestyle',
          selectedLifestyle,
          const ['Very Active', 'Active', 'Somewhat Active', 'Not Very Active'],
          FontAwesomeIcons.dumbbell,
          Colors.green,
          onLifestyleChanged,
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
        border: Border.all(color: Colors.pink.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.calendar, color: Colors.pink, size: 16),
              const SizedBox(width: 8),
              Text(
                'Age Range',
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${ageRange.start.round()} - ${ageRange.end.round()} years',
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
            values: ageRange,
            min: 18,
            max: 65,
            divisions: 47,
            activeColor: Colors.pink,
            inactiveColor: Colors.pink.withOpacity(0.3),
            labels: RangeLabels(
              ageRange.start.round().toString(),
              ageRange.end.round().toString(),
            ),
            onChanged: onAgeRangeChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceSlider(BuildContext context) {
    final theme = Theme.of(context);
    String distanceText = distance >= 25 ? '25km+' : '${distance.round()}km';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.locationDot, color: Colors.blue, size: 16),
              const SizedBox(width: 8),
              Text('Distance', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
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
            value: distance,
            min: 2,
            max: 25,
            divisions: 23,
            activeColor: Colors.blue,
            inactiveColor: Colors.blue.withOpacity(0.3),
            label: distanceText,
            onChanged: onDistanceChanged,
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
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const FaIcon(FontAwesomeIcons.infinity, color: Colors.purple, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Region - Infinity', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  region,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRegionChanged,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.blue.shade400]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.globe, color: Colors.white, size: 14),
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
      ValueChanged<String?>? onChanged,
      ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: currentValue,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: FaIcon(FontAwesomeIcons.chevronDown, size: 12, color: color),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  dropdownColor: theme.cardColor,
                  onChanged: onChanged,
                  items: options.map((value) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
