import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isGradient;
  final List<Color>? gradientColors;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height = 50,
    this.borderRadius = 25,
    this.padding,
    this.isGradient = false,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final defaultGradientColors = [
      colorScheme.primary,
      colorScheme.secondary,
    ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isGradient && !isOutlined
            ? LinearGradient(
                colors: gradientColors ?? defaultGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isGradient || isOutlined ? null : (backgroundColor ?? colorScheme.primary),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isOutlined
            ? Border.all(
                color: backgroundColor ?? colorScheme.primary,
                width: 2,
              )
            : null,
        boxShadow: !isOutlined
            ? [
                BoxShadow(
                  color: (backgroundColor ?? colorScheme.primary).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOutlined
                            ? (backgroundColor ?? colorScheme.primary)
                            : (textColor ?? Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else if (icon != null) ...[
                  FaIcon(
                    icon,
                    size: 18,
                    color: isOutlined
                        ? (backgroundColor ?? colorScheme.primary)
                        : (textColor ?? Colors.white),
                  ),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: isOutlined
                          ? (backgroundColor ?? colorScheme.primary)
                          : (textColor ?? Colors.white),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Specialized button variants
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final String? ThemeData;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.ThemeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isGradient: true,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      isOutlined: true,
    );
  }
}

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool hasShadow;

  const IconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 50,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size / 2),
          child: Center(
            child: FaIcon(
              icon,
              color: iconColor ?? colorScheme.primary,
              size: size * 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
