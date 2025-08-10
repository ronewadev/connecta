import 'package:flutter/material.dart';

class StyledChip extends StatelessWidget {
  final String label;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final TextStyle? textStyle;
  final List<Color>? gradientColors;
  final bool showShadow;

  const StyledChip({
    Key? key,
    required this.label,
    required this.color,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderWidth = 2,
    this.shadowBlurRadius = 8,
    this.shadowOffset = const Offset(0, 2),
    this.textStyle,
    this.gradientColors,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? [
            color.withOpacity(0.8),
            color.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: borderWidth,
        ),
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: shadowBlurRadius,
            offset: shadowOffset,
          ),
        ]
            : null,
      ),
      child: Text(
        label,
        style: textStyle ??
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
      ),
    );
  }
}