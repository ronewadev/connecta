// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import '../../../models/user_model.dart';
//
// class MatchDialogService {
//   static void showMatchDialog({
//     required BuildContext context,
//     required UserModelInfo matchedUser,
//     VoidCallback? onKeepSwiping,
//     VoidCallback? onSayHi,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => _buildMatchDialog(matchedUser, onKeepSwiping, onSayHi),
//     );
//   }
//
//   static Widget _buildMatchDialog(
//       UserModelInfo matchedUser,
//       VoidCallback? onKeepSwiping,
//       VoidCallback? onSayHi,
//       ) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.pink.shade50,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildHeartIcon(),
//           const SizedBox(height: 20),
//           _buildTitle(context),
//           const SizedBox(height: 8),
//           _buildSubtitle(matchedUser, context),
//           const SizedBox(height: 20),
//           _buildActionButtons(onKeepSwiping, onSayHi, context),
//         ],
//       ),
//     );
//   }
//
//   static Widget _buildHeartIcon() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.pink,
//         shape: BoxShape.circle,
//       ),
//       child: const FaIcon(
//         FontAwesomeIcons.heart,
//         color: Colors.white,
//         size: 40,
//       ),
//     );
//   }
//
//   static Widget _buildTitle(BuildContext context) {
//     return Text(
//       'It\'s a Match!',
//       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//         fontWeight: FontWeight.bold,
//         color: Colors.pink,
//       ),
//     );
//   }
//
//   static Widget _buildSubtitle(UserModelInfo matchedUser, BuildContext context) {
//     return Text(
//       'You and ${matchedUser.username} liked each other!',
//       textAlign: TextAlign.center,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         color: Colors.pink.shade700,
//       ),
//     );
//   }
//
//   static Widget _buildActionButtons(
//       VoidCallback? onKeepSwiping,
//       VoidCallback? onSayHi,
//       BuildContext context,
//       ) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextButton(
//             onPressed: onKeepSwiping ?? () => Navigator.pop(context),
//             child: const Text('Keep Swiping'),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: ElevatedButton(
//             onPressed: onSayHi ?? () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Chat feature coming soon!')),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.pink,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Say Hi!'),
//           ),
//         ),
//       ],
//     );
//   }
// }