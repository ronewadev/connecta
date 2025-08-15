import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onBoost;
  final double iconSize;
  final double buttonSize;
  final double spacing;

  const ActionButtonsRow({
    Key? key,
    required this.onUndo,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onBoost,
    this.iconSize = 32,
    this.buttonSize = 54,
    this.spacing = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          icon: FontAwesomeIcons.rotateLeft,
          color: Colors.amber,
          onPressed: onUndo,
        ),
        SizedBox(width: spacing),
        _buildActionButton(
          icon: FontAwesomeIcons.xmark,
          color: Colors.red,
          onPressed: onDislike,
        ),
        SizedBox(width: spacing),
        _buildActionButton(
          icon: FontAwesomeIcons.star,
          color: Colors.blue,
          onPressed: onSuperLike,
        ),
        SizedBox(width: spacing),
        _buildActionButton(
          icon: FontAwesomeIcons.heart,
          color: Colors.green,
          onPressed: onLike,
        ),
        SizedBox(width: spacing),
        _buildActionButton(
          icon: FontAwesomeIcons.bolt,
          color: Colors.purple,
          onPressed: onBoost,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(buttonSize / 2),
          onTap: onPressed,
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}