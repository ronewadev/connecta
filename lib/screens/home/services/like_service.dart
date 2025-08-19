// import 'package:http/http.dart' as ApiService show get;
//
// import '../../../services/like_service.dart';
//
// class LikeService {
//   static Future<bool> sendLike(String userId, LikeType likeType) async {
//     try {
//       final response = await ApiService.post('/likes', {
//         'targetUserId': userId,
//         'type': likeType.name,
//       });
//
//       return response.statusCode == 200;
//     } catch (e) {
//       print('Error sending like: $e');
//       return false;
//     }
//   }
//
//   static Future<bool> isMatch(String userId) async {
//     try {
//       final response = await ApiService.get('/matches/check/$userId');
//       return response.statusCode == 200 && response.data['isMatch'] == true;
//     } catch (e) {
//       print('Error checking match: $e');
//       return false;
//     }
//   }
// }