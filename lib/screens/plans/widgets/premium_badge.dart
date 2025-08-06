import 'package:flutter/material.dart';

class PremiumBadge extends StatelessWidget {
  final String type;

  const PremiumBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: type == 'infinity' ? Colors.deepPurple : Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type == 'infinity' ? 'INFINITY' : 'PREMIUM',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}