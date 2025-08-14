import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import '../models/user_model.dart';
import '../models/match_score_model.dart';
import '../models/match_preferences.dart';
import 'match_users.dart';

class MatchService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth.FirebaseAuth _auth = FirebaseAuth.FirebaseAuth.instance;
  
  static String? get _currentUserId => _auth.currentUser?.uid;

  /// Get real-time potential matches stream with extensive logging
  static Stream<List<UserModelInfo>> getPotentialMatchesStream({
    int limit = 50,
    MatchPreferences? preferences,
  }) async* {
    print('🔍 MatchService: Starting getPotentialMatchesStream');
    print('📊 Parameters: limit=$limit, preferences=$preferences');
    print('👤 Current user ID: $_currentUserId');

    if (_currentUserId == null) {
      print('❌ No current user - returning empty list');
      yield [];
      return;
    }

    try {
      print('🚀 Attempting to find matches using MatchUsersService...');
      
      // Get matches using existing match algorithm
      final matches = await MatchUsersService.findMatches(
        limit: limit,
        maxDistance: preferences?.maxDistance?.toDouble() ?? 50.0,
        minAge: preferences?.ageRangeMin ?? 18,
        maxAge: preferences?.ageRangeMax ?? 65,
      );
      
      print('✅ Initial matches found: ${matches.length}');
      matches.forEach((user) {
        print('   👥 User: ${user.username} (${user.id}) - Age: ${user.age}');
      });
      
      yield matches;
      
      // Set up real-time listener for user updates
      print('📡 Setting up real-time listener...');
      await for (final snapshot in _firestore.collection('users').snapshots()) {
        print('🔄 Users collection updated - ${snapshot.docs.length} total users');
        print('📝 Changed documents: ${snapshot.docChanges.length}');
        
        final updatedMatches = await MatchUsersService.findMatches(
          limit: limit,
          maxDistance: preferences?.maxDistance?.toDouble() ?? 50.0,
          minAge: preferences?.ageRangeMin ?? 18,
          maxAge: preferences?.ageRangeMax ?? 65,
        );
        
        print('🔄 Updated matches: ${updatedMatches.length}');
        yield updatedMatches;
      }
    } catch (e, stackTrace) {
      print('💥 Error in getPotentialMatchesStream: $e');
      print('📍 Stack trace: $stackTrace');
      yield [];
    }
  }

  /// Record user interaction with logging
  static Future<bool> recordInteraction({
    required String toUserId,
    required InteractionType type,
  }) async {
    print('💕 Recording interaction: $_currentUserId -> $toUserId ($type)');
    
    if (_currentUserId == null) {
      print('❌ No current user for interaction');
      return false;
    }

    try {
      final batch = _firestore.batch();
      
      // Create interaction document
      final interactionRef = _firestore.collection('interactions').doc();
      final interaction = UserInteraction(
        fromUserId: _currentUserId!,
        toUserId: toUserId,
        type: type,
      );
      
      print('📝 Creating interaction document: ${interactionRef.id}');
      batch.set(interactionRef, interaction.toMap());

      // Update target user's "liked by" arrays
      final targetUserRef = _firestore.collection('users').doc(toUserId);
      
      switch (type) {
        case InteractionType.like:
          print('❤️ Adding to likesMe array');
          batch.update(targetUserRef, {
            'likesMe': FieldValue.arrayUnion([_currentUserId])
          });
          break;
        case InteractionType.superLike:
          print('⭐ Adding to superLikesMe array');
          batch.update(targetUserRef, {
            'superLikesMe': FieldValue.arrayUnion([_currentUserId])
          });
          break;
        case InteractionType.love:
          print('💖 Adding to lovesMe array');
          batch.update(targetUserRef, {
            'lovesMe': FieldValue.arrayUnion([_currentUserId])
          });
          break;
        default:
          print('🚫 No action for interaction type: $type');
          break;
      }

      // Check if this creates a match
      print('🔍 Checking for potential match...');
      await _checkAndCreateMatch(_currentUserId!, toUserId, type);

      await batch.commit();
      print('✅ Interaction recorded successfully');
      return true;
    } catch (e, stackTrace) {
      print('💥 Error recording interaction: $e');
      print('📍 Stack trace: $stackTrace');
      return false;
    }
  }

  /// Check if interaction creates a match with logging
  static Future<void> _checkAndCreateMatch(
    String fromUserId, 
    String toUserId, 
    InteractionType type
  ) async {
    print('🤝 Checking for match: $fromUserId <-> $toUserId');
    
    try {
      // Only likes, super likes, and loves can create matches
      if (![InteractionType.like, InteractionType.superLike, InteractionType.love].contains(type)) {
        print('🚫 Interaction type $type cannot create matches');
        return;
      }

      // Check if target user has also liked the current user
      print('📖 Fetching target user document...');
      final targetUserDoc = await _firestore.collection('users').doc(toUserId).get();
      if (!targetUserDoc.exists) {
        print('❌ Target user document does not exist');
        return;
      }

      final targetUserData = targetUserDoc.data()!;
      final likesMe = List<String>.from(targetUserData['likesMe'] ?? []);
      final superLikesMe = List<String>.from(targetUserData['superLikesMe'] ?? []);
      final lovesMe = List<String>.from(targetUserData['lovesMe'] ?? []);

      print('📊 Target user interactions:');
      print('   ❤️ Likes me: $likesMe');
      print('   ⭐ Super likes me: $superLikesMe');
      print('   💖 Loves me: $lovesMe');

      // Check if there's mutual interest
      final hasMutualInterest = likesMe.contains(fromUserId) || 
                               superLikesMe.contains(fromUserId) || 
                               lovesMe.contains(fromUserId);

      print('🤔 Has mutual interest: $hasMutualInterest');

      if (hasMutualInterest) {
        // Create match
        print('🎉 Creating new match!');
        final matchRef = _firestore.collection('matches').doc();
        final match = Match(
          id: matchRef.id,
          user1Id: fromUserId,
          user2Id: toUserId,
        );
        await matchRef.set(match.toMap());
        print('✅ Match created with ID: ${matchRef.id}');
      } else {
        print('😔 No mutual interest - no match created');
      }
    } catch (e, stackTrace) {
      print('💥 Error checking for match: $e');
      print('📍 Stack trace: $stackTrace');
    }
  }

  /// Get matches for current user with logging
  static Stream<List<Match>> getMatchesStream() {
    print('💑 Getting matches stream for user: $_currentUserId');
    
    if (_currentUserId == null) {
      print('❌ No current user for matches');
      return Stream.value([]);
    }

    return _firestore
        .collection('matches')
        .where('user1Id', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
          print('📊 Matches query result: ${snapshot.docs.length} matches');
          final matches = snapshot.docs
              .map((doc) => Match.fromMap(doc.data(), doc.id))
              .toList();
          
          matches.forEach((match) {
            print('   💑 Match: ${match.user1Id} <-> ${match.user2Id}');
          });
          
          return matches;
        });
  }

  /// Get users who liked the current user with logging
  static Stream<List<UserModelInfo>> getLikedByUsersStream() {
    print('👀 Getting liked by users stream for: $_currentUserId');
    
    if (_currentUserId == null) {
      print('❌ No current user for liked by stream');
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(_currentUserId)
        .snapshots()
        .asyncMap((userSnapshot) async {
      print('📖 Current user document updated');
      
      if (!userSnapshot.exists) {
        print('❌ Current user document does not exist');
        return <UserModelInfo>[];
      }

      final userData = userSnapshot.data()!;
      final likedByIds = List<String>.from(userData['likesMe'] ?? []);
      final superLikedByIds = List<String>.from(userData['superLikesMe'] ?? []);
      final lovedByIds = List<String>.from(userData['lovesMe'] ?? []);

      print('📊 Users who interacted with me:');
      print('   ❤️ Liked by: $likedByIds');
      print('   ⭐ Super liked by: $superLikedByIds');
      print('   💖 Loved by: $lovedByIds');

      final allLikedByIds = {...likedByIds, ...superLikedByIds, ...lovedByIds}.toList();
      print('📝 Total unique interactions: ${allLikedByIds.length}');

      if (allLikedByIds.isEmpty) {
        print('😔 No users have interacted with me');
        return <UserModelInfo>[];
      }

      try {
        print('🔍 Fetching user details for interacting users...');
        final usersSnapshot = await _firestore
            .collection('users')
            .where(FieldPath.documentId, whereIn: allLikedByIds)
            .get();

        print('📊 Found ${usersSnapshot.docs.length} user documents');
        
        final users = usersSnapshot.docs
            .map((doc) {
              try {
                final user = UserModelInfo.fromMap(doc.data(), doc.id);
                print('   👤 Loaded user: ${user.username} (${user.id})');
                return user;
              } catch (e) {
                print('💥 Error parsing user ${doc.id}: $e');
                return null;
              }
            })
            .where((user) => user != null)
            .cast<UserModelInfo>()
            .toList();

        print('✅ Successfully loaded ${users.length} users who liked me');
        return users;
      } catch (e, stackTrace) {
        print('💥 Error fetching liked by users: $e');
        print('📍 Stack trace: $stackTrace');
        return <UserModelInfo>[];
      }
    });
  }

  /// Remove interaction with logging
  static Future<bool> removeInteraction({
    required String toUserId,
    required InteractionType type,
  }) async {
    print('🗑️ Removing interaction: $_currentUserId -> $toUserId ($type)');
    
    if (_currentUserId == null) {
      print('❌ No current user for removing interaction');
      return false;
    }

    try {
      final targetUserRef = _firestore.collection('users').doc(toUserId);
      
      switch (type) {
        case InteractionType.like:
          print('❤️ Removing from likesMe array');
          await targetUserRef.update({
            'likesMe': FieldValue.arrayRemove([_currentUserId])
          });
          break;
        case InteractionType.superLike:
          print('⭐ Removing from superLikesMe array');
          await targetUserRef.update({
            'superLikesMe': FieldValue.arrayRemove([_currentUserId])
          });
          break;
        case InteractionType.love:
          print('💖 Removing from lovesMe array');
          await targetUserRef.update({
            'lovesMe': FieldValue.arrayRemove([_currentUserId])
          });
          break;
        default:
          print('🚫 No action for removing interaction type: $type');
          break;
      }

      print('✅ Interaction removed successfully');
      return true;
    } catch (e, stackTrace) {
      print('💥 Error removing interaction: $e');
      print('📍 Stack trace: $stackTrace');
      return false;
    }
  }
}