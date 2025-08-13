import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/match_score_model.dart';

class MatchUsersService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _currentUserId => _auth.currentUser?.uid;

  static Future<List<UserModelInfo>> findMatches({
    int limit = 50,
    double maxDistance = 50.0,
    int minAge = 18,
    int maxAge = 65,
  }) async {
    try {
      print('DEBUG: Finding matches for user: $_currentUserId');
      
      if (_currentUserId == null) {
        print('ERROR: No authenticated user');
        return [];
      }

      // Get current user
      final currentUserDoc = await _firestore.collection('users').doc(_currentUserId).get();
      if (!currentUserDoc.exists) {
        print('ERROR: Current user document does not exist');
        return [];
      }

      final currentUserData = currentUserDoc.data()!;
      final currentUser = UserModelInfo.fromMap(currentUserData, _currentUserId!);
      print('DEBUG: Current user loaded - ${currentUser.username}, ${currentUser.age} years old');

      // Get potential matches
      print('DEBUG: Getting potential matches for ${currentUser.username}');
      final potentialMatches = await _getPotentialMatches(currentUser, minAge, maxAge, maxDistance);
      print('DEBUG: Found ${potentialMatches.length} potential matches');

      // Score and sort matches
      final scoredMatches = await _scoreMatches(currentUser, potentialMatches);
      print('DEBUG: Scored matches count: ${scoredMatches.length}');

      // Sort by overall score (highest first)
      scoredMatches.sort((a, b) => b.overallScore.compareTo(a.overallScore));

      // Get top matches up to limit
      final topMatches = scoredMatches.take(limit).map((score) {
        return potentialMatches.firstWhere((user) => user.id == score.userId);
      }).toList();

      print('DEBUG: Final scored matches count: ${topMatches.length}');
      print('DEBUG: Returning ${topMatches.length} matches to UI');

      return topMatches;
    } catch (e, stackTrace) {
      print('Error finding matches: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<List<UserModelInfo>> _getPotentialMatches(
    UserModelInfo currentUser,
    int minAge,
    int maxAge,
    double maxDistance,
  ) async {
    try {
      print('DEBUG: Excluding current user: ${currentUser.id}');
      
      // Get current user's preferences
      final preferredGender = currentUser.preferences['preferredGender'];
      print('DEBUG: Current user preferred gender: $preferredGender');

      Query query = _firestore.collection('users');

      // Exclude current user
      query = query.where(FieldPath.documentId, isNotEqualTo: currentUser.id);

      // Age filter
      query = query.where('age', isGreaterThanOrEqualTo: minAge);
      query = query.where('age', isLessThanOrEqualTo: maxAge);

      // Gender filter if specified
      if (preferredGender != null && preferredGender != 'Everyone') {
        print('DEBUG: Filtering by gender: $preferredGender');
        query = query.where('gender', isEqualTo: preferredGender);
      }

      final snapshot = await query.get();
      print('DEBUG: Raw query returned ${snapshot.docs.length} users');

      final potentialMatches = <UserModelInfo>[];
      
      for (final doc in snapshot.docs) {
        try {
          // Add detailed debugging for each user document
          final userData = doc.data() as Map<String, dynamic>;
          print('DEBUG: Processing user ${doc.id} - ${userData['username'] ?? 'No username'}');
          
          // Add more specific debugging for the problematic field
          if (userData.containsKey('interests')) {
            final interests = userData['interests'];
            print('DEBUG: User interests type: ${interests.runtimeType}, value: $interests');
            
            // Ensure interests is a List<String>
            if (interests is List) {
              final stringInterests = interests.map((e) => e.toString()).toList();
              userData['interests'] = stringInterests;
              print('DEBUG: Converted interests to: $stringInterests');
            }
          }
          
          if (userData.containsKey('hobbies')) {
            final hobbies = userData['hobbies'];
            print('DEBUG: User hobbies type: ${hobbies.runtimeType}, value: $hobbies');
            
            // Ensure hobbies is a List<String>
            if (hobbies is List) {
              final stringHobbies = hobbies.map((e) => e.toString()).toList();
              userData['hobbies'] = stringHobbies;
              print('DEBUG: Converted hobbies to: $stringHobbies');
            }
          }

          // Convert other potentially problematic List fields
          final listFields = ['dealBreakers', 'socialMediaLinks', 'profileImages', 'likesMe', 'superLikesMe', 'lovesMe'];
          for (final field in listFields) {
            if (userData.containsKey(field)) {
              final fieldValue = userData[field];
              if (fieldValue is List) {
                userData[field] = fieldValue.map((e) => e.toString()).toList();
                print('DEBUG: Converted $field to List<String>');
              }
            }
          }

          final user = UserModelInfo.fromMap(userData, doc.id);
          potentialMatches.add(user);
          print('DEBUG: Successfully added user: ${user.username}');
          
        } catch (e, stackTrace) {
          print('ERROR: Failed to parse user ${doc.id}: $e');
          print('ERROR: Stack trace: $stackTrace');
          print('ERROR: User data: ${doc.data()}');
          continue; // Skip this user and continue with others
        }
      }

      print('DEBUG: Successfully processed ${potentialMatches.length} potential matches');
      return potentialMatches;
      
    } catch (e, stackTrace) {
      print('Error getting potential matches: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<List<MatchScore>> _scoreMatches(
    UserModelInfo currentUser,
    List<UserModelInfo> potentialMatches,
  ) async {
    final scoredMatches = <MatchScore>[];

    for (final user in potentialMatches) {
      try {
        print('DEBUG: Scoring match for ${user.username}');
        
        // Calculate different compatibility scores
        final interestScore = _calculateInterestCompatibility(currentUser, user);
        final hobbyScore = _calculateHobbyCompatibility(currentUser, user);
        final ageScore = _calculateAgeCompatibility(currentUser, user);
        final locationScore = _calculateLocationCompatibility(currentUser, user);
        final profileScore = _calculateProfileCompleteness(user);
        final activityScore = user.isOnline ? 1.0 : 0.5;
        final preferenceScore = _calculatePreferenceMatch(currentUser, user);

        // Calculate overall score (weighted average)
        final overallScore = (
          interestScore * 0.25 +
          hobbyScore * 0.20 +
          ageScore * 0.15 +
          locationScore * 0.15 +
          profileScore * 0.10 +
          activityScore * 0.05 +
          preferenceScore * 0.10
        );

        final matchScore = MatchScore(
          userId: user.id,
          overallScore: overallScore,
          interestScore: interestScore,
          hobbyScore: hobbyScore,
          locationScore: locationScore,
          ageScore: ageScore,
          activityScore: activityScore,
          profileScore: profileScore,
          preferenceScore: preferenceScore,
        );

        scoredMatches.add(matchScore);
        print('DEBUG: User ${user.username} scored: ${overallScore.toStringAsFixed(2)}');
        
      } catch (e, stackTrace) {
        print('ERROR: Failed to score user ${user.username}: $e');
        print('ERROR: Stack trace: $stackTrace');
        continue; // Skip scoring this user
      }
    }

    return scoredMatches;
  }

  static double _calculateInterestCompatibility(UserModelInfo user1, UserModelInfo user2) {
    try {
      if (user1.interests.isEmpty || user2.interests.isEmpty) return 0.0;
      
      final commonInterests = user1.interests.where((interest) =>
          user2.interests.any((otherInterest) => 
              interest.toLowerCase().contains(otherInterest.toLowerCase()) ||
              otherInterest.toLowerCase().contains(interest.toLowerCase())
          )
      ).length;
      
      final totalInterests = (user1.interests.length + user2.interests.length) / 2;
      return commonInterests / totalInterests;
    } catch (e) {
      print('ERROR: Interest compatibility calculation failed: $e');
      return 0.0;
    }
  }

  static double _calculateHobbyCompatibility(UserModelInfo user1, UserModelInfo user2) {
    try {
      if (user1.hobbies.isEmpty || user2.hobbies.isEmpty) return 0.0;
      
      final commonHobbies = user1.hobbies.where((hobby) =>
          user2.hobbies.any((otherHobby) => 
              hobby.toLowerCase().contains(otherHobby.toLowerCase()) ||
              otherHobby.toLowerCase().contains(hobby.toLowerCase())
          )
      ).length;
      
      final totalHobbies = (user1.hobbies.length + user2.hobbies.length) / 2;
      return commonHobbies / totalHobbies;
    } catch (e) {
      print('ERROR: Hobby compatibility calculation failed: $e');
      return 0.0;
    }
  }

  static double _calculateAgeCompatibility(UserModelInfo user1, UserModelInfo user2) {
    try {
      final ageDifference = (user1.age - user2.age).abs();
      if (ageDifference <= 2) return 1.0;
      if (ageDifference <= 5) return 0.8;
      if (ageDifference <= 10) return 0.5;
      return 0.2;
    } catch (e) {
      print('ERROR: Age compatibility calculation failed: $e');
      return 0.0;
    }
  }

  static double _calculateLocationCompatibility(UserModelInfo user1, UserModelInfo user2) {
    try {
      if (user1.userLocation != null && user2.userLocation != null) {
        final distance = user1.userLocation!.distanceTo(user2.userLocation!);
        if (distance <= 10) return 1.0;
        if (distance <= 25) return 0.8;
        if (distance <= 50) return 0.6;
        if (distance <= 100) return 0.4;
        return 0.2;
      }
      
      // Fallback to city/location comparison
      if (user1.location == user2.location) return 0.8;
      if (user1.currentCity == user2.currentCity) return 0.6;
      return 0.3;
    } catch (e) {
      print('ERROR: Location compatibility calculation failed: $e');
      return 0.3;
    }
  }

  static double _calculateProfileCompleteness(UserModelInfo user) {
    try {
      int completenessScore = 0;
      
      if (user.bio != null && user.bio!.isNotEmpty) completenessScore++;
      if (user.profileImages.isNotEmpty) completenessScore++;
      if (user.interests.isNotEmpty) completenessScore++;
      if (user.hobbies.isNotEmpty) completenessScore++;
      if (user.isVerified) completenessScore++;
      
      return completenessScore / 5.0;
    } catch (e) {
      print('ERROR: Profile completeness calculation failed: $e');
      return 0.0;
    }
  }

  static double _calculatePreferenceMatch(UserModelInfo currentUser, UserModelInfo otherUser) {
    try {
      double score = 1.0;
      
      // Check deal breakers
      for (final dealBreaker in currentUser.dealBreakers) {
        if (otherUser.interests.contains(dealBreaker) || 
            otherUser.hobbies.contains(dealBreaker)) {
          score -= 0.5;
        }
      }
      
      return score.clamp(0.0, 1.0);
    } catch (e) {
      print('ERROR: Preference match calculation failed: $e');
      return 1.0;
    }
  }
}
