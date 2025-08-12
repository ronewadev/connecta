import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewHeader extends StatelessWidget {
  final bool isGridView;
  final bool showFilters;
  final VoidCallback onToggleFilters;
  final VoidCallback onSwitchToGrid;
  final VoidCallback onSwitchToCard;

  const ViewHeader({
    Key? key,
    required this.isGridView,
    required this.showFilters,
    required this.onToggleFilters,
    required this.onSwitchToGrid,
    required this.onSwitchToCard,
  }) : super(key: key);

  Widget _buildViewToggleButton({
    required ThemeData theme,
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: FaIcon(
        icon,
        size: 20,
        color: isActive ? Colors.white : theme.colorScheme.primary,
      ),
      style: IconButton.styleFrom(
        backgroundColor: isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.primary.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // View toggle buttons
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildViewToggleButton(
                  theme: theme,
                  icon: FontAwesomeIcons.layerGroup,
                  isActive: !isGridView,
                  onPressed: onSwitchToCard,
                ),
                _buildViewToggleButton(
                  theme: theme,
                  icon: FontAwesomeIcons.tableCells,
                  isActive: isGridView,
                  onPressed: onSwitchToGrid,
                ),
              ],
            ),
          ),

          const Spacer(),

          // View label
          Text(
            isGridView ? 'Grid View' : 'Card View',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),

          const Spacer(),

          // Filter button
          Container(
            decoration: BoxDecoration(
              color: showFilters
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onToggleFilters,
              icon: FaIcon(
                FontAwesomeIcons.sliders,
                color: showFilters ? Colors.white : theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
