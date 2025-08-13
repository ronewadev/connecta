import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewHeader extends StatelessWidget {
  final bool isGridView;
  final bool showFilters;
  final VoidCallback onToggleFilters;
  final VoidCallback onSwitchToGrid;
  final VoidCallback onSwitchToCard;

  const ViewHeader({
    super.key,
    required this.isGridView,
    required this.showFilters,
    required this.onToggleFilters,
    required this.onSwitchToGrid,
    required this.onSwitchToCard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 10),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // App title
          Expanded(
            child: Text(
              'Discover',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          
          // View toggle buttons
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card view button
                GestureDetector(
                  onTap: onSwitchToCard,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: !isGridView ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 16,
                      color: !isGridView 
                        ? Colors.white 
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // Grid view button
                GestureDetector(
                  onTap: onSwitchToGrid,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isGridView ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.grip,
                      size: 16,
                      color: isGridView 
                        ? Colors.white 
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Filter button
          GestureDetector(
            onTap: onToggleFilters,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: showFilters 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: FaIcon(
                FontAwesomeIcons.sliders,
                size: 16,
                color: showFilters 
                  ? Colors.white 
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}