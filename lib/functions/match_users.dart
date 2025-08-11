import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connecta/models/user_model.dart' as UserModel;
import 'dart:math' as Math;

class MatchUsersService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  static String? get _currentUserId => _auth.currentUser?.uid;

  /// Main function to find potential matches for the current user
  static Future<List<UserModel.User>> findMatches({
    int limit = 50,
    double maxDistance = 50.0, // km
    int minAge = 18,
    int maxAge = 65,
  }) async {
    try {
      if (_currentUserId == null) {
        print('DEBUG: No current user ID found');
        return [];
      }

      print('DEBUG: Finding matches for user: $_currentUserId');

      // Get current user data
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .get();

      if (!currentUserDoc.exists) {
        print('DEBUG: Current user document does not exist');
        return [];
      }

      final currentUser = UserModel.User.fromMap(
        currentUserDoc.data()!,
        _currentUserId!,
      );

      print('DEBUG: Current user loaded - ${currentUser.username}, ${currentUser.age} years old');

      // Get all potential matches with basic filtering
      final potentialMatches = await _getPotentialMatches(
        currentUser,
        limit * 2, // Get more to filter better
        minAge,
        maxAge,
      );

      print('DEBUG: Found ${potentialMatches.length} potential matches');

      // Calculate match scores and filter
      final scoredMatches = <MapEntry<UserModel.User, double>>[];

      for (final user in potentialMatches) {
        final score = _calculateMatchScore(currentUser, user);
        print('DEBUG: Match score for ${user.username}: $score');
        // Lower the threshold to 0.1 to ensure we find matches
        if (score > 0.1) { 
          scoredMatches.add(MapEntry(user, score));
        }
      }

      print('DEBUG: Scored matches count: ${scoredMatches.length}');

      // If we still don't have enough matches, add all potential matches with minimum score
      if (scoredMatches.length < 5 && potentialMatches.isNotEmpty) {
        print('DEBUG: Not enough high-scoring matches, adding all potential matches');
        for (final user in potentialMatches) {
          final score = _calculateMatchScore(currentUser, user);
          if (!scoredMatches.any((entry) => entry.key.id == user.id)) {
            scoredMatches.add(MapEntry(user, Math.max(score, 0.1)));
          }
        }
      }

      // Sort by match score (highest first)
      scoredMatches.sort((a, b) => b.value.compareTo(a.value));

      // If we still don't have any matches, try a more lenient approach
      if (scoredMatches.isEmpty && potentialMatches.isNotEmpty) {
        print('DEBUG: No scored matches found, adding all potential matches with basic score');
        for (final user in potentialMatches) {
          scoredMatches.add(MapEntry(user, 0.2)); // Give everyone a minimum score
        }
      }

      print('DEBUG: Final scored matches count: ${scoredMatches.length}');

      // Return top matches
      final result = scoredMatches
          .take(limit)
          .map((entry) => entry.key)
          .toList();
      
      print('DEBUG: Returning ${result.length} matches to UI');
      return result;

    } catch (e) {
      print('Error finding matches: $e');
      return [];
    }
  }

  /// Get potential matches with basic filtering
  static Future<List<UserModel.User>> _getPotentialMatches(
    UserModel.User currentUser,
    int limit,
    int minAge,
    int maxAge,
  ) async {
    try {
      print('DEBUG: Getting potential matches for ${currentUser.username}');
      
      // Build query based on preferences
      Query query = _firestore.collection('users');

      // Exclude current user
      query = query.where(FieldPath.documentId, isNotEqualTo: _currentUserId);
      print('DEBUG: Excluding current user: $_currentUserId');

      // Filter by preferred gender
      final preferredGender = currentUser.preferences['preferredGender'] as String?;
      print('DEBUG: Current user preferred gender: $preferredGender');
      if (preferredGender != null && preferredGender.isNotEmpty && preferredGender != 'Everyone') {
        query = query.where('gender', isEqualTo: preferredGender);
        print('DEBUG: Filtering by gender: $preferredGender');
      }

      // Filter by age range
      final ageRangeMin = currentUser.preferences['ageRange']?['min'] ?? minAge;
      final ageRangeMax = currentUser.preferences['ageRange']?['max'] ?? maxAge;
      
      print('DEBUG: Age range filter: $ageRangeMin - $ageRangeMax');
      query = query.where('age', isGreaterThanOrEqualTo: ageRangeMin);
      query = query.where('age', isLessThanOrEqualTo: ageRangeMax);

      // Limit results - remove ordering to avoid Firestore index issues
      query = query.limit(limit);

      print('DEBUG: Executing Firestore query...');
      final snapshot = await query.get();
      print('DEBUG: Query returned ${snapshot.docs.length} documents');
      
      // If no results, try a broader query without age restrictions
      QuerySnapshot broadSnapshot;
      if (snapshot.docs.isEmpty) {
        print('DEBUG: No results from filtered query, trying broader query...');
        Query broadQuery = _firestore.collection('users');
        broadQuery = broadQuery.where(FieldPath.documentId, isNotEqualTo: _currentUserId);
        
        // Only apply gender filter if set
        if (preferredGender != null && preferredGender.isNotEmpty && preferredGender != 'Everyone') {
          broadQuery = broadQuery.where('gender', isEqualTo: preferredGender);
        }
        
        broadQuery = broadQuery.limit(limit);
        broadSnapshot = await broadQuery.get();
        print('DEBUG: Broad query returned ${broadSnapshot.docs.length} documents');
      } else {
        broadSnapshot = snapshot;
      }
      
      final users = <UserModel.User>[];

      for (final doc in broadSnapshot.docs) {
        if (doc.data() != null) {
          print('DEBUG: Processing user document: ${doc.id}');
          final user = UserModel.User.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
          print('DEBUG: Loaded user: ${user.username}, age ${user.age}, gender ${user.gender}');

          // Additional filtering
          if (_passesBasicFilters(currentUser, user)) {
            users.add(user);
            print('DEBUG: User ${user.username} passed basic filters');
          } else {
            print('DEBUG: User ${user.username} did not pass basic filters');
          }
        }
      }

      print('DEBUG: Final potential matches count: ${users.length}');
      return users;
    } catch (e) {
      print('Error getting potential matches: $e');
      return [];
    }
  }

  /// Check if user passes basic compatibility filters
  static bool _passesBasicFilters(UserModel.User currentUser, UserModel.User potentialMatch) {
    print('DEBUG: Checking basic filters for ${potentialMatch.username}');
    
    // ALWAYS respect gender preferences - this is non-negotiable
    if (!_areMutuallyCompatible(currentUser, potentialMatch)) {
      print('DEBUG: User ${potentialMatch.username} rejected - gender preference mismatch');
      return false;
    }

    // Check distance if both users have location data (but be more lenient)
    if (currentUser.userLocation != null && potentialMatch.userLocation != null) {
      final distance = currentUser.userLocation!.distanceTo(potentialMatch.userLocation!);
      final maxDistance = (currentUser.preferences['distance']?.toDouble() ?? 50.0) * 2; // Double the distance tolerance
      
      print('DEBUG: Distance check - ${distance}km vs ${maxDistance}km max (2x tolerance)');
      if (distance > maxDistance) {
        print('DEBUG: User ${potentialMatch.username} rejected - too far (${distance}km)');
        return false;
      }
    } else {
      print('DEBUG: No location data for distance check - allowing match');
    }

    // Relax deal breaker checking - only reject if it's a major conflict
    if (_hasCriticalDealBreakers(currentUser, potentialMatch)) {
      print('DEBUG: User ${potentialMatch.username} rejected - critical deal breaker');
      return false;
    }

    // Check if user has been previously rejected/liked (avoid showing again)
    // This would require tracking user interactions
    
    print('DEBUG: User ${potentialMatch.username} passed all basic filters');
    return true;
  }

  /// Check for critical deal breakers only (not all deal breakers)
  static bool _hasCriticalDealBreakers(UserModel.User currentUser, UserModel.User potentialMatch) {
    // Only check for critical deal breakers like age extremes, etc.
    // Most deal breakers should be handled by scoring, not hard filtering
    
    // For now, we'll be very lenient and only reject extreme cases
    final ageDiff = (currentUser.age - potentialMatch.age).abs();
    if (ageDiff > 30) return true; // Reject if age difference is extreme
    
    return false;
  }

  /// Calculate comprehensive match score (0.0 to 1.0)
  static double _calculateMatchScore(UserModel.User currentUser, UserModel.User potentialMatch) {
    double totalScore = 0.0;
    int factorCount = 0;

    // 1. Interest compatibility (30% weight)
    final interestScore = _calculateInterestCompatibility(currentUser, potentialMatch);
    totalScore += interestScore * 0.30;
    factorCount++;

    // 2. Hobby compatibility (20% weight)
    final hobbyScore = _calculateHobbyCompatibility(currentUser, potentialMatch);
    totalScore += hobbyScore * 0.20;
    factorCount++;

    // 3. Location proximity (15% weight)
    final locationScore = _calculateLocationScore(currentUser, potentialMatch);
    totalScore += locationScore * 0.15;
    factorCount++;

    // 4. Age compatibility (10% weight)
    final ageScore = _calculateAgeCompatibility(currentUser, potentialMatch);
    totalScore += ageScore * 0.10;
    factorCount++;

    // 5. Subscription tier compatibility (5% weight)
    final subscriptionScore = _calculateSubscriptionCompatibility(currentUser, potentialMatch);
    totalScore += subscriptionScore * 0.05;
    factorCount++;

    // 6. Activity score (online/last active) (10% weight)
    final activityScore = _calculateActivityScore(potentialMatch);
    totalScore += activityScore * 0.10;
    factorCount++;

    // 7. Profile completeness (5% weight)
    final profileScore = _calculateProfileCompleteness(potentialMatch);
    totalScore += profileScore * 0.05;
    factorCount++;

    // 8. Preference alignment (5% weight)
    final preferenceScore = _calculatePreferenceAlignment(currentUser, potentialMatch);
    totalScore += preferenceScore * 0.05;
    factorCount++;

    return factorCount > 0 ? totalScore : 0.0;
  }

  /// Calculate interest compatibility score
  static double _calculateInterestCompatibility(UserModel.User user1, UserModel.User user2) {
    if (user1.interests.isEmpty || user2.interests.isEmpty) return 0.5; // Higher neutral score

    final commonInterests = user1.interests.toSet().intersection(user2.interests.toSet()).length;
    final totalUniqueInterests = user1.interests.toSet().union(user2.interests.toSet()).length;

    if (totalUniqueInterests == 0) return 0.5;
    
    // Give a minimum score boost to ensure some compatibility
    final baseScore = commonInterests / totalUniqueInterests;
    return Math.max(baseScore, 0.3); // Minimum 0.3 score
  }

  /// Calculate hobby compatibility score
  static double _calculateHobbyCompatibility(UserModel.User user1, UserModel.User user2) {
    if (user1.hobbies.isEmpty || user2.hobbies.isEmpty) return 0.5; // Higher neutral score

    final commonHobbies = user1.hobbies.toSet().intersection(user2.hobbies.toSet()).length;
    final totalUniqueHobbies = user1.hobbies.toSet().union(user2.hobbies.toSet()).length;

    if (totalUniqueHobbies == 0) return 0.5;
    
    // Give a minimum score boost
    final baseScore = commonHobbies / totalUniqueHobbies;
    return Math.max(baseScore, 0.3); // Minimum 0.3 score
  }

  /// Calculate location proximity score
  static double _calculateLocationScore(UserModel.User user1, UserModel.User user2) {
    if (user1.userLocation == null || user2.userLocation == null) {
      // Fall back to city comparison
      if (user1.currentCity != null && user2.currentCity != null) {
        return user1.currentCity!.toLowerCase() == user2.currentCity!.toLowerCase() ? 0.8 : 0.5;
      }
      return 0.6; // Higher neutral score if no location data
    }

    final distance = user1.userLocation!.distanceTo(user2.userLocation!);
    
    // More forgiving distance scoring
    if (distance <= 10) return 1.0;     // Within 10km
    if (distance <= 25) return 0.9;     // Within 25km
    if (distance <= 50) return 0.8;     // Within 50km
    if (distance <= 100) return 0.6;    // Within 100km
    if (distance <= 200) return 0.4;    // Within 200km
    return 0.3;                         // Give some score even for far distances
  }

  /// Calculate age compatibility score
  static double _calculateAgeCompatibility(UserModel.User user1, UserModel.User user2) {
    final ageDiff = (user1.age - user2.age).abs();
    
    if (ageDiff <= 2) return 1.0;
    if (ageDiff <= 5) return 0.8;
    if (ageDiff <= 10) return 0.6;
    if (ageDiff <= 15) return 0.4;
    if (ageDiff <= 20) return 0.2;
    return 0.1;
  }

  /// Calculate subscription tier compatibility
  static double _calculateSubscriptionCompatibility(UserModel.User user1, UserModel.User user2) {
    final tier1 = _getSubscriptionTier(user1.subscription.type);
    final tier2 = _getSubscriptionTier(user2.subscription.type);
    
    final tierDiff = (tier1 - tier2).abs();
    
    if (tierDiff == 0) return 1.0;  // Same tier
    if (tierDiff == 1) return 0.8;  // Adjacent tiers
    if (tierDiff == 2) return 0.6;  // Two tiers apart
    return 0.4;                     // Very different tiers
  }

  /// Get numeric tier for subscription type
  static int _getSubscriptionTier(String subscriptionType) {
    switch (subscriptionType.toLowerCase()) {
      case 'basic': return 1;
      case 'premium': return 2;
      case 'elite': return 3;
      case 'infinity': return 4;
      default: return 1;
    }
  }

  /// Calculate activity score (how recently active)
  static double _calculateActivityScore(UserModel.User user) {
    if (user.isOnline) return 1.0;
    
    final now = DateTime.now();
    final lastActive = user.lastActive;
    final hoursSinceActive = now.difference(lastActive).inHours;
    
    if (hoursSinceActive <= 1) return 0.9;
    if (hoursSinceActive <= 6) return 0.8;
    if (hoursSinceActive <= 24) return 0.6;
    if (hoursSinceActive <= 72) return 0.4;
    if (hoursSinceActive <= 168) return 0.2; // 1 week
    return 0.1;
  }

  /// Calculate profile completeness score
  static double _calculateProfileCompleteness(UserModel.User user) {
    int completeness = 0;
    int totalFields = 10;
    
    if (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty) completeness++;
    if (user.profileImages.isNotEmpty) completeness++;
    if (user.bio != null && user.bio!.isNotEmpty) completeness++;
    if (user.interests.isNotEmpty) completeness++;
    if (user.hobbies.isNotEmpty) completeness++;
    if (user.dealBreakers.isNotEmpty) completeness++;
    if (user.userLocation != null) completeness++;
    if (user.age > 0) completeness++;
    if (user.gender.isNotEmpty && user.gender != 'Not specified') completeness++;
    if (user.nationality.isNotEmpty && user.nationality != 'Not specified') completeness++;
    
    return completeness / totalFields;
  }

  /// Calculate preference alignment score
  static double _calculatePreferenceAlignment(UserModel.User user1, UserModel.User user2) {
    double alignmentScore = 0.0;
    int comparisons = 0;

    // Compare education preferences
    final education1 = user1.preferences['education'] as String?;
    final education2 = user2.preferences['education'] as String?;
    if (education1 != null && education2 != null) {
      alignmentScore += education1 == education2 ? 1.0 : 0.5;
      comparisons++;
    }

    // Compare lifestyle preferences
    final lifestyle1 = user1.preferences['lifestyle'] as String?;
    final lifestyle2 = user2.preferences['lifestyle'] as String?;
    if (lifestyle1 != null && lifestyle2 != null) {
      alignmentScore += lifestyle1 == lifestyle2 ? 1.0 : 0.5;
      comparisons++;
    }

    // Compare relationship type preferences
    final relationshipType1 = user1.preferences['relationshipType'] as String?;
    final relationshipType2 = user2.preferences['relationshipType'] as String?;
    if (relationshipType1 != null && relationshipType2 != null) {
      alignmentScore += relationshipType1 == relationshipType2 ? 1.0 : 0.3;
      comparisons++;
    }

    return comparisons > 0 ? alignmentScore / comparisons : 0.5;
  }

  /// Check if users have matching deal breakers
  static bool _hasMatchingDealBreakers(UserModel.User currentUser, UserModel.User potentialMatch) {
    // This is a simplified check - you might want to expand this based on specific deal breakers
    // For now, we'll assume deal breakers are traits the user doesn't want in a match
    
    for (final dealBreaker in potentialMatch.dealBreakers) {
      // Check if current user has traits that match potential match's deal breakers
      if (currentUser.interests.any((interest) => 
          interest.toLowerCase().contains(dealBreaker.toLowerCase()))) {
        return true;
      }
      if (currentUser.hobbies.any((hobby) => 
          hobby.toLowerCase().contains(dealBreaker.toLowerCase()))) {
        return true;
      }
    }
    
    // Check vice versa
    for (final dealBreaker in currentUser.dealBreakers) {
      if (potentialMatch.interests.any((interest) => 
          interest.toLowerCase().contains(dealBreaker.toLowerCase()))) {
        return true;
      }
      if (potentialMatch.hobbies.any((hobby) => 
          hobby.toLowerCase().contains(dealBreaker.toLowerCase()))) {
        return true;
      }
    }
    
    return false;
  }

  /// Check if users are mutually compatible (interested in each other's gender)
  static bool _areMutuallyCompatible(UserModel.User user1, UserModel.User user2) {
    final user1PreferredGender = user1.preferences['preferredGender'] as String?;
    final user2PreferredGender = user2.preferences['preferredGender'] as String?;
    
    print('DEBUG: Checking gender compatibility:');
    print('DEBUG: ${user1.username} (${user1.gender}) prefers: ${user1PreferredGender ?? "not set"}');
    print('DEBUG: ${user2.username} (${user2.gender}) prefers: ${user2PreferredGender ?? "not set"}');
    
    // If either has no preference, assume compatible
    if (user1PreferredGender == null || user2PreferredGender == null) {
      print('DEBUG: One user has no preference - compatible');
      return true;
    }
    if (user1PreferredGender == 'Everyone' || user2PreferredGender == 'Everyone') {
      print('DEBUG: At least one user accepts everyone - compatible');
      return true;
    }
    
    // Check if each user's gender matches the other's preference
    final user1CompatibleWithUser2 = user1PreferredGender == user2.gender || user1PreferredGender == 'Everyone';
    final user2CompatibleWithUser1 = user2PreferredGender == user1.gender || user2PreferredGender == 'Everyone';
    
    final result = user1CompatibleWithUser2 && user2CompatibleWithUser1;
    print('DEBUG: User1->User2 compatible: $user1CompatibleWithUser2, User2->User1 compatible: $user2CompatibleWithUser1, Result: $result');
    
    return result;
  }

  /// Get matches with detailed scoring information (for debugging/analytics)
  static Future<List<Map<String, dynamic>>> findMatchesWithScores({
    int limit = 20,
    double maxDistance = 50.0,
    int minAge = 18,
    int maxAge = 65,
  }) async {
    try {
      if (_currentUserId == null) return [];

      final currentUserDoc = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .get();

      if (!currentUserDoc.exists) return [];

      final currentUser = UserModel.User.fromMap(
        currentUserDoc.data()!,
        _currentUserId!,
      );

      final potentialMatches = await _getPotentialMatches(
        currentUser,
        limit * 2,
        minAge,
        maxAge,
      );

      final scoredMatches = <Map<String, dynamic>>[];

      for (final user in potentialMatches) {
        final overallScore = _calculateMatchScore(currentUser, user);
        
        if (overallScore > 0.3) {
          scoredMatches.add({
            'user': user,
            'overallScore': overallScore,
            'interestScore': _calculateInterestCompatibility(currentUser, user),
            'hobbyScore': _calculateHobbyCompatibility(currentUser, user),
            'locationScore': _calculateLocationScore(currentUser, user),
            'ageScore': _calculateAgeCompatibility(currentUser, user),
            'activityScore': _calculateActivityScore(user),
            'profileScore': _calculateProfileCompleteness(user),
            'preferenceScore': _calculatePreferenceAlignment(currentUser, user),
          });
        }
      }

      // Sort by overall score
      scoredMatches.sort((a, b) => (b['overallScore'] as double).compareTo(a['overallScore'] as double));

      return scoredMatches.take(limit).toList();

    } catch (e) {
      print('Error finding matches with scores: $e');
      return [];
    }
  }

  /// Get users within a specific radius
  static Future<List<UserModel.User>> findUsersNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
    int limit = 50,
  }) async {
    try {
      if (_currentUserId == null) return [];

      // Create a temporary location object for distance calculations
      final searchLocation = UserModel.UserLocation(
        latitude: latitude,
        longitude: longitude,
        address: '',
        city: '',
        country: '',
        lastUpdated: DateTime.now(),
      );

      // Get all users (we'll filter by distance afterward due to Firestore limitations)
      final snapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isNotEqualTo: _currentUserId)
          .limit(limit * 3) // Get more to filter by distance
          .get();

      final nearbyUsers = <UserModel.User>[];

      for (final doc in snapshot.docs) {
        if (doc.data() != null) {
          final user = UserModel.User.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );

          // Check if user has location data and is within radius
          if (user.userLocation != null) {
            final distance = searchLocation.distanceTo(user.userLocation!);
            if (distance <= radiusKm) {
              nearbyUsers.add(user);
            }
          }
        }

        // Stop if we have enough users
        if (nearbyUsers.length >= limit) break;
      }

      // Sort by distance
      nearbyUsers.sort((a, b) {
        if (a.userLocation == null || b.userLocation == null) return 0;
        final distanceA = searchLocation.distanceTo(a.userLocation!);
        final distanceB = searchLocation.distanceTo(b.userLocation!);
        return distanceA.compareTo(distanceB);
      });

      return nearbyUsers.take(limit).toList();

    } catch (e) {
      print('Error finding nearby users: $e');
      return [];
    }
  }

  /// Filter matches by specific criteria
  static List<UserModel.User> filterMatches(
    List<UserModel.User> matches, {
    String? subscriptionType,
    bool? isOnline,
    List<String>? requiredInterests,
    int? minAge,
    int? maxAge,
  }) {
    return matches.where((user) {
      if (subscriptionType != null && user.subscription.type != subscriptionType) {
        return false;
      }
      
      if (isOnline != null && user.isOnline != isOnline) {
        return false;
      }
      
      if (requiredInterests != null && requiredInterests.isNotEmpty) {
        final hasRequiredInterests = requiredInterests.any(
          (interest) => user.interests.contains(interest)
        );
        if (!hasRequiredInterests) return false;
      }
      
      if (minAge != null && user.age < minAge) {
        return false;
      }
      
      if (maxAge != null && user.age > maxAge) {
        return false;
      }
      
      return true;
    }).toList();
  }
}
