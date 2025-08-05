import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                  ? [
                      const Color(0xFF2D2D2D).withOpacity(0.8),
                      const Color(0xFF1A1A1A).withOpacity(0.6)
                    ]
                  : [
                      Colors.white.withOpacity(0.8),
                      Colors.grey.shade50.withOpacity(0.6)
                    ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark 
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                    ? Colors.black.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
                BoxShadow(
                  color: isDark 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.8),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(FontAwesomeIcons.house, 0, 'Home'),
                  _buildNavItem(FontAwesomeIcons.play, 1, 'Live'),
                  _buildNavItem(FontAwesomeIcons.commentDots, 2, 'Chat'),
                  _buildNavItem(FontAwesomeIcons.solidHeart, 3, 'Likes'),
                  _buildNavItem(FontAwesomeIcons.crown, 4, 'Premium'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, String label) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isSelected = index == currentIndex;
        final isDark = theme.brightness == Brightness.dark;
        
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected 
                ? LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.3),
                      theme.colorScheme.primary.withOpacity(0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
              borderRadius: BorderRadius.circular(20),
              border: isSelected 
                ? Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.4),
                    width: 1,
                  )
                : null,
              boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: isSelected ? const EdgeInsets.all(4) : EdgeInsets.zero,
                  decoration: isSelected
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      )
                    : null,
                  child: FaIcon(
                    icon,
                    color: isSelected 
                      ? (isSelected ? Colors.white : theme.colorScheme.primary)
                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    size: isSelected ? 20 : 18,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
