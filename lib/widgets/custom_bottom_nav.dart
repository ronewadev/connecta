import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.pink, Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(FontAwesomeIcons.fire, 0, currentIndex, onTap, showDot: false),
            _buildNavItem(FontAwesomeIcons.earthAfrica, 1, currentIndex, onTap, showDot: false),
            _buildNavItem(FontAwesomeIcons.commentDots, 2, currentIndex, onTap, showDot: true),
            _buildNavItem(FontAwesomeIcons.user, 3, currentIndex, onTap, showDot: false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon,
      int index,
      int currentIndex,
      Function(int) onTap, {
        bool showDot = false,
      }) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (showDot)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
