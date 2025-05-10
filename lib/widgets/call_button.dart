import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CallButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 36, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}