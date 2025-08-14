class MatchScore {
  final String userId;
  final double overallScore;
  final double interestScore;
  final double hobbyScore;
  final double locationScore;
  final double ageScore;
  final double activityScore;
  final double profileScore;
  final double preferenceScore;
  final DateTime calculatedAt;

  MatchScore({
    required this.userId,
    required this.overallScore,
    required this.interestScore,
    required this.hobbyScore,
    required this.locationScore,
    required this.ageScore,
    required this.activityScore,
    required this.profileScore,
    required this.preferenceScore,
    DateTime? calculatedAt,
  }) : calculatedAt = calculatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'overallScore': overallScore,
      'interestScore': interestScore,
      'hobbyScore': hobbyScore,
      'locationScore': locationScore,
      'ageScore': ageScore,
      'activityScore': activityScore,
      'profileScore': profileScore,
      'preferenceScore': preferenceScore,
      'calculatedAt': calculatedAt,
    };
  }

  factory MatchScore.fromMap(Map<String, dynamic> map) {
    return MatchScore(
      userId: map['userId'] ?? '',
      overallScore: (map['overallScore'] ?? 0.0).toDouble(),
      interestScore: (map['interestScore'] ?? 0.0).toDouble(),
      hobbyScore: (map['hobbyScore'] ?? 0.0).toDouble(),
      locationScore: (map['locationScore'] ?? 0.0).toDouble(),
      ageScore: (map['ageScore'] ?? 0.0).toDouble(),
      activityScore: (map['activityScore'] ?? 0.0).toDouble(),
      profileScore: (map['profileScore'] ?? 0.0).toDouble(),
      preferenceScore: (map['preferenceScore'] ?? 0.0).toDouble(),
      calculatedAt: map['calculatedAt']?.toDate() ?? DateTime.now(),
    );
  }
}

class UserInteraction {
  final String fromUserId;
  final String toUserId;
  final InteractionType type;
  final DateTime timestamp;

  UserInteraction({
    required this.fromUserId,
    required this.toUserId,
    required this.type,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'type': type.toString(),
      'timestamp': timestamp,
    };
  }

  factory UserInteraction.fromMap(Map<String, dynamic> map) {
    return UserInteraction(
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? '',
      type: InteractionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => InteractionType.like,
      ),
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
    );
  }
}

enum InteractionType { like, superLike, love, dislike, block, report }

class Match {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime matchedAt;
  final bool isActive;

  Match({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    DateTime? matchedAt,
    this.isActive = true,
  }) : matchedAt = matchedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'matchedAt': matchedAt,
      'isActive': isActive,
    };
  }

  factory Match.fromMap(Map<String, dynamic> map, String documentId) {
    return Match(
      id: documentId,
      user1Id: map['user1Id'] ?? '',
      user2Id: map['user2Id'] ?? '',
      matchedAt: map['matchedAt']?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }
}