// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../../../models/user_model.dart';
// import '../../../services/like_service.dart';
//
// class InteractionService {
//   final BuildContext context;
//   final Function(UserModelInfo) showMatchDialog;
//   final Function(String) removeUserAfterInteraction;
//
//   InteractionService({
//     required this.context,
//     required this.showMatchDialog,
//     required this.removeUserAfterInteraction,
//   });
//
//   Future<void> handleLike(UserModelInfo user) async {
//     await _handleInteraction(
//       user: user,
//       likeType: LikeType.like,
//       successMessage: 'Liked ${user.username}!',
//       feedbackText: 'LIKE',
//       feedbackColor: Colors.green,
//       feedbackIcon: FontAwesomeIcons.heart,
//     );
//   }
//
//   Future<void> handleSuperLike(UserModelInfo user) async {
//     await _handleInteraction(
//       user: user,
//       likeType: LikeType.superLike,
//       successMessage: 'Super Liked ${user.username}!',
//       feedbackText: 'SUPER\nLIKE',
//       feedbackColor: Colors.blue,
//       feedbackIcon: FontAwesomeIcons.star,
//     );
//   }
//
//   Future<void> handleLove(UserModelInfo user) async {
//     await _handleInteraction(
//       user: user,
//       likeType: LikeType.love,
//       successMessage: 'Loved ${user.username}!',
//       feedbackText: 'LOVE',
//       feedbackColor: Colors.pink,
//       feedbackIcon: FontAwesomeIcons.heart,
//     );
//   }
//
//   Future<void> handleDislike(UserModelInfo user) async {
//     removeUserAfterInteraction(user.id);
//
//     final success = await LikeService.sendLike(user.id, LikeType.dislike);
//
//     if (success) {
//       _showFeedback(
//         text: 'NOPE',
//         color: Colors.red,
//         icon: FontAwesomeIcons.heartCrack,
//       );
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Passed on ${user.username}'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }
//
//   Future<void> _handleInteraction({
//     required UserModelInfo user,
//     required LikeType likeType,
//     required String successMessage,
//     required String feedbackText,
//     required Color feedbackColor,
//     required IconData feedbackIcon,
//   }) async {
//     removeUserAfterInteraction(user.id);
//
//     final success = await LikeService.sendLike(user.id, likeType);
//
//     if (success) {
//       _showFeedback(
//         text: feedbackText,
//         color: feedbackColor,
//         icon: feedbackIcon,
//       );
//
//       final isMatch = await LikeService.isMatch(user.id);
//       if (isMatch) {
//         showMatchDialog(user);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: _buildSnackbarContent(successMessage, feedbackIcon),
//             backgroundColor: feedbackColor,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } else {
//       _showErrorSnackbar('Failed to send ${likeType.name}. Please try again.');
//     }
//   }
//
//   Widget _buildSnackbarContent(String message, IconData icon) {
//     return Row(
//       children: [
//         FaIcon(icon, color: Colors.white, size: 16),
//         const SizedBox(width: 8),
//         Text(message),
//       ],
//     );
//   }
//
//   void _showFeedback({
//     required String text,
//     required Color color,
//     required IconData icon,
//   }) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FaIcon(icon, color: Colors.white, size: 16),
//             const SizedBox(width: 8),
//             Text(text),
//           ],
//         ),
//         backgroundColor: color,
//         duration: const Duration(milliseconds: 800),
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.only(bottom: 100, left: 50, right: 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
//
//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }
//
// late InteractionService _interactionService;
//
// @override
// void initState() {
//   super.initState();
//   _currentUserId = FirebaseAuth.instance.currentUser?.uid;
//   _swiperController = CardSwiperController();
//   _feedbackController = AnimationController(
//     duration: const Duration(milliseconds: 600),
//     vsync: this,
//   );
//   _interactionService = InteractionService(
//     context: context,
//     showMatchDialog: _showMatchDialog,
//     removeUserAfterInteraction: _removeUserAfterInteraction,
//   );
//   _setupRealtimeMatches();
// }