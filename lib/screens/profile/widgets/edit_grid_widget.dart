import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditGrid extends StatelessWidget {
  final List<String> availableItems;
  final List<String> selectedItems;
  final Color primaryColor;
  final int maxItems;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;
  final TextStyle? selectedTitleStyle;
  final TextStyle? availableTitleStyle;
  final double chipSpacing;
  final double sectionSpacing;
  final bool showMaxLimitMessage;

  const EditGrid({
    super.key,
    required this.availableItems,
    required this.selectedItems,
    required this.primaryColor,
    required this.maxItems,
    required this.onAdd,
    required this.onRemove,
    this.selectedTitleStyle,
    this.availableTitleStyle,
    this.chipSpacing = 8,
    this.sectionSpacing = 16,
    this.showMaxLimitMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unselectedItems = availableItems.where((item) => !selectedItems.contains(item)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedItems.isNotEmpty) ...[
          Text(
            'Selected:',
            style: selectedTitleStyle ??
                TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          SizedBox(height: chipSpacing),
          Wrap(
            spacing: chipSpacing,
            runSpacing: chipSpacing,
            children: selectedItems.map((item) => Chip(
              label: Text(item),
              backgroundColor: primaryColor.withOpacity(0.2),
              deleteIcon: const FaIcon(FontAwesomeIcons.xmark, size: 14),
              onDeleted: () => onRemove(item),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )).toList(),
          ),
          SizedBox(height: sectionSpacing),
        ],

        if (selectedItems.length < maxItems) ...[
          Text(
            'Available:',
            style: availableTitleStyle ??
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          SizedBox(height: chipSpacing),
          Wrap(
            spacing: chipSpacing,
            runSpacing: chipSpacing,
            children: unselectedItems.map((item) => ActionChip(
              label: Text(item),
              backgroundColor: Colors.grey.withOpacity(0.1),
              onPressed: () => onAdd(item),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            )).toList(),
          ),
        ] else if (showMaxLimitMessage) ...[
          Text(
            'Maximum $maxItems items selected',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}