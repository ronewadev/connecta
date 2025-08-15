import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LikeType { like, superLike, love, dislike, nope }

class LikeService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send a like to another user and record interaction
  static Future<bool> sendLike(String targetUserId, LikeType likeType) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return false;
      }

      final String currentUserId = currentUser.uid;
      print('💝 Sending ${likeType.name} from $currentUserId to $targetUserId');

      // Check if interaction already exists (bidirectional)
      final existingInteraction = await _checkExistingInteraction(currentUserId, targetUserId);
      if (existingInteraction) {
        print('⚠️ Interaction already exists between $currentUserId and $targetUserId');
        return true; // Return true since interaction exists but we don't want to show error
      }

      // Use a batch to ensure atomic operations
      final batch = _firestore.batch();

      // 1. Record the interaction in the interactions collection
      final interactionRef = _firestore.collection('interactions').doc();
      batch.set(interactionRef, {
        'fromUserId': currentUserId,
        'toUserId': targetUserId,
        'type': 'InteractionType.${likeType.name}',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Update target user's arrays only for positive interactions
      if ([LikeType.like, LikeType.superLike, LikeType.love].contains(likeType)) {
        final targetUserRef = _firestore.collection('users').doc(targetUserId);
        
        switch (likeType) {
          case LikeType.like:
            batch.update(targetUserRef, {
              'likesMe': FieldValue.arrayUnion([currentUserId])
            });
            print('➕ Added to likesMe: $currentUserId');
            break;
          case LikeType.superLike:
            batch.update(targetUserRef, {
              'superLikesMe': FieldValue.arrayUnion([currentUserId])
            });
            print('⭐ Added to superLikesMe: $currentUserId');
            break;
          case LikeType.love:
            batch.update(targetUserRef, {
              'lovesMe': FieldValue.arrayUnion([currentUserId])
            });
            print('❤️ Added to lovesMe: $currentUserId');
            break;
          default:
            break;
        }
      }

      // Commit the batch
      await batch.commit();

      print('✅ Successfully sent ${likeType.name} to $targetUserId and recorded interaction');
      return true;

    } catch (e) {
      print('💥 Error sending like: $e');
      return false;
    }
  }

  /// Check if interaction already exists between two users (bidirectional)
  static Future<bool> _checkExistingInteraction(String fromUserId, String toUserId) async {
    try {
      // Check both directions
      final querySnapshot1 = await _firestore
          .collection('interactions')
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .limit(1)
          .get();

      final querySnapshot2 = await _firestore
          .collection('interactions')
          .where('fromUserId', isEqualTo: toUserId)
          .where('toUserId', isEqualTo: fromUserId)
          .limit(1)
          .get();
      
      return querySnapshot1.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty;
    } catch (e) {
      print('💥 Error checking existing interaction: $e');
      return false;
    }
  }

  /// Get all users the current user has interacted with (bidirectional)
  static Future<Set<String>> getInteractedUserIds() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return <String>{};
      }

      final String currentUserId = currentUser.uid;
      print('📊 Getting interacted users for: $currentUserId');

      // Get interactions where current user is the sender
      final querySnapshot1 = await _firestore
          .collection('interactions')
          .where('fromUserId', isEqualTo: currentUserId)
          .get();

      // Get interactions where current user is the receiver  
      final querySnapshot2 = await _firestore
          .collection('interactions')
          .where('toUserId', isEqualTo: currentUserId)
          .get();

      final interactedUserIds = <String>{};
      
      // Add users where current user sent interactions
      for (var doc in querySnapshot1.docs) {
        interactedUserIds.add(doc.data()['toUserId'] as String);
      }
      
      // Add users where current user received interactions
      for (var doc in querySnapshot2.docs) {
        interactedUserIds.add(doc.data()['fromUserId'] as String);
      }

      print('📊 Found ${interactedUserIds.length} interacted users: $interactedUserIds');
      return interactedUserIds;

    } catch (e) {
      print('💥 Error getting interacted user IDs: $e');
      return <String>{};
    }
  }

  /// Remove a like from another user (for undo functionality)
  static Future<bool> removeLike(String targetUserId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return false;
      }

      final String currentUserId = currentUser.uid;
      print('🔄 Removing like from $currentUserId to $targetUserId');

      final batch = _firestore.batch();

      // 1. Remove the interaction from interactions collection
      final interactionQuery = await _firestore
          .collection('interactions')
          .where('fromUserId', isEqualTo: currentUserId)
          .where('toUserId', isEqualTo: targetUserId)
          .limit(1)
          .get();

      if (interactionQuery.docs.isNotEmpty) {
        batch.delete(interactionQuery.docs.first.reference);
      }

      // 2. Remove from target user's arrays
      final targetUserRef = _firestore.collection('users').doc(targetUserId);
      batch.update(targetUserRef, {
        'likesMe': FieldValue.arrayRemove([currentUserId]),
        'superLikesMe': FieldValue.arrayRemove([currentUserId]),
        'lovesMe': FieldValue.arrayRemove([currentUserId]),
      });

      await batch.commit();

      print('✅ Successfully removed like from $targetUserId');
      return true;

    } catch (e) {
      print('💥 Error removing like: $e');
      return false;
    }
  }

  /// Get users who liked the current user
  static Future<Map<String, List<String>>> getMyLikes() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('❌ No authenticated user');
        return {
          'likesMe': [],
          'superLikesMe': [],
          'lovesMe': [],
        };
      }

      final String currentUserId = currentUser.uid;
      print('📊 Getting likes for user: $currentUserId');

      final userDoc = await _firestore.collection('users').doc(currentUserId).get();
      
      if (!userDoc.exists) {
        print('❌ User document not found');
        return {
          'likesMe': [],
          'superLikesMe': [],
          'lovesMe': [],
        };
      }

      final userData = userDoc.data()!;
      
      final result = {
        'likesMe': List<String>.from(userData['likesMe'] ?? []),
        'superLikesMe': List<String>.from(userData['superLikesMe'] ?? []),
        'lovesMe': List<String>.from(userData['lovesMe'] ?? []),
      };

      print('📊 Current user likes:');
      print('   👍 Likes: ${result['likesMe']!.length}');
      print('   ⭐ Super Likes: ${result['superLikesMe']!.length}');
      print('   ❤️ Loves: ${result['lovesMe']!.length}');

      return result;

    } catch (e) {
      print('💥 Error getting my likes: $e');
      return {
        'likesMe': [],
        'superLikesMe': [],
        'lovesMe': [],
      };
    }
  }

  /// Check if two users mutually liked each other (it's a match)
  static Future<bool> isMatch(String otherUserId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final String currentUserId = currentUser.uid;

      // Check if current user is in other user's likes
      final otherUserDoc = await _firestore.collection('users').doc(otherUserId).get();
      if (!otherUserDoc.exists) return false;

      final otherUserData = otherUserDoc.data()!;
      List<String> otherUserLikes = [
        ...List<String>.from(otherUserData['likesMe'] ?? []),
        ...List<String>.from(otherUserData['superLikesMe'] ?? []),
        ...List<String>.from(otherUserData['lovesMe'] ?? []),
      ];

      bool currentUserLikedOther = otherUserLikes.contains(currentUserId);

      if (!currentUserLikedOther) return false;

      // Check if other user is in current user's likes
      final currentUserDoc = await _firestore.collection('users').doc(currentUserId).get();
      if (!currentUserDoc.exists) return false;

      final currentUserData = currentUserDoc.data()!;
      List<String> currentUserLikes = [
        ...List<String>.from(currentUserData['likesMe'] ?? []),
        ...List<String>.from(currentUserData['superLikesMe'] ?? []),
        ...List<String>.from(currentUserData['lovesMe'] ?? []),
      ];

      bool otherUserLikedCurrent = currentUserLikes.contains(otherUserId);

      return currentUserLikedOther && otherUserLikedCurrent;

    } catch (e) {
      print('💥 Error checking match: $e');
      return false;
    }
  }

  /// Get real-time stream of likes for current user
  static Stream<Map<String, List<String>>> getMyLikesStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value({
        'likesMe': [],
        'superLikesMe': [],
        'lovesMe': [],
      });
    }

    return _firestore.collection('users').doc(currentUser.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return {
          'likesMe': [],
          'superLikesMe': [],
          'lovesMe': [],
        };
      }

      final data = doc.data()!;
      return {
        'likesMe': List<String>.from(data['likesMe'] ?? []),
        'superLikesMe': List<String>.from(data['superLikesMe'] ?? []),
        'lovesMe': List<String>.from(data['lovesMe'] ?? []),
      };
    });
  }
}