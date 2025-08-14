import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'action_button.dart';

class ActionButtonsRow2 extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onDislike;
  final VoidCallback onSuperLike;
  final VoidCallback onLike;
  final VoidCallback onBoost;

  const ActionButtonsRow2({
    Key? key,
    required this.onUndo,
    required this.onDislike,
    required this.onSuperLike,
    required this.onLike,
    required this.onBoost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            icon: FontAwesomeIcons.rotateLeft,
            color: Colors.amber,
            onPressed: onUndo,
          ),
          ActionButton(
            icon: FontAwesomeIcons.xmark,
            color: Colors.red,
            onPressed: onDislike,
          ),
          ActionButton(
            icon: FontAwesomeIcons.star,
            color: Colors.blue,
            onPressed: onSuperLike,
          ),
          ActionButton(
            icon: FontAwesomeIcons.heart,
            color: Colors.green,
            onPressed: onLike,
          ),
          ActionButton(
            icon: FontAwesomeIcons.bolt,
            color: Colors.purple,
            onPressed: () {
              HapticFeedback.mediumImpact();
              onBoost();
            },
          ),
        ],
      ),
    );
  }
}
