import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Widget content;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadows;
  final double iconSize;
  final double chevronSize;
  final double spacing;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isExpanded,
    required this.onToggle,
    required this.content,
    this.padding,
    this.borderRadius,
    this.shadows,
    this.iconSize = 16,
    this.chevronSize = 16,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      )
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: shadows ?? defaultShadows,
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggle,
            borderRadius: borderRadius?.resolve(TextDirection.ltr)?.topLeft == null
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.only(
              topLeft: borderRadius!.resolve(TextDirection.ltr)!.topLeft,
              topRight: borderRadius!.resolve(TextDirection.ltr)!.topRight,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      icon,
                      color: color,
                      size: iconSize,
                    ),
                  ),
                  SizedBox(width: spacing),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: FaIcon(
                      FontAwesomeIcons.chevronDown,
                      size: chevronSize,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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
            child: isExpanded ? Container(
              padding: padding?.copyWith(
                top: 0,
                bottom: padding?.vertical ?? 20,
                left: padding?.horizontal ?? 20,
                right: padding?.horizontal ?? 20,
              ) ?? const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: content,
            ) : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

extension on EdgeInsetsGeometry? {
  copyWith({required int top, required double bottom, required double left, required double right}) {}
}