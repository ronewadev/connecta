import 'package:connecta/screens/profile/widgets/stlyled_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
  final bool isEditing;
  final List<String>? tempItems;
  final int? maxItems;
  final VoidCallback? onEdit;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final Function(String)? onAdd;
  final Function(String)? onRemove;
  final List<String>? availableItems;
  final bool isLoading;

  const SubSection({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    this.isEditing = false,
    this.tempItems,
    this.maxItems,
    this.onEdit,
    this.onSave,
    this.onCancel,
    this.onAdd,
    this.onRemove,
    this.availableItems,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        isEditing ? _buildEditContent(context) : _buildViewContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isEditing
                  ? [color, color.withOpacity(0.7)]
                  : [color.withOpacity(0.8), color.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: isEditing ? 8 : 12,
                offset: Offset(0, isEditing ? 2 : 4),
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
        if (!isEditing && onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: const FaIcon(
              FontAwesomeIcons.penToSquare,
              size: 16,
            ),
            color: color,
          ),
      ],
    );
  }

  Widget _buildViewContent(BuildContext context) {
    final theme = Theme.of(context);
    return items.isNotEmpty
        ? Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) => StyledChip(
                  label: item,
                  color: color,
                )).toList(),
          )
        : Container(
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
          );
  }

  Widget _buildEditContent(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Edit $title (${tempItems?.length ?? 0}/${maxItems ?? 0})',
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildEditGrid(context),
        ],
      ),
    );
  }

  Widget _buildEditGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableItems?.map((item) {
        final isSelected = tempItems?.contains(item) ?? false;
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              if (tempItems?.length ?? 0 < (maxItems ?? 0)) {
                onAdd?.call(item);
              }
            } else {
              onRemove?.call(item);
            }
          },
          selectedColor: color.withOpacity(0.3),
          checkmarkColor: color,
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? color : Colors.grey.withOpacity(0.3),
            ),
          ),
          labelStyle: TextStyle(
            color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
          ),
        );
      }).toList() ?? [],
    );
  }
}

// Example Usage:
/*
// View Mode
SubSection(
  title: 'Interests',
  icon: FontAwesomeIcons.heart,
  color: Colors.pink,
  items: ['Hiking', 'Reading', 'Photography'],
)

// Edit Mode
SubSection(
  title: 'Interests',
  icon: FontAwesomeIcons.heart,
  color: Colors.pink,
  items: currentItems,
  isEditing: true,
  tempItems: tempItems,
  maxItems: 5,
  availableItems: allPossibleItems,
  onEdit: () => setState(() => isEditing = true),
  onSave: saveChanges,
  onCancel: cancelEditing,
  onAdd: addItem,
  onRemove: removeItem,
)
*/