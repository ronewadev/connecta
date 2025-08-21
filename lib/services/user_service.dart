import '../models/match_score_model.dart';
import '../models/user_model.dart';
import '../services/match_service.dart';

class UserService {
  // Demo local user list with realistic data
  final List<UserModelInfo> _users = [
    UserModelInfo(
      id: 'demo_user_1',
      username: 'Sarah',
      email: 'sarah@connecta.com',
      age: 27,
      gender: 'Female',
      nationality: 'USA',
      location: 'New York',
      profileImageUrl: 'https://i.pravatar.cc/500?img=47',
      interests: ['Photography', 'Hiking', 'Art', 'Cooking'],
      bio: 'Adventure seeker and coffee enthusiast. Looking to meet new people!',
      isVerified: true,
      isOnline: true, // Add this
      socialMedia: const {},
    ),
  ];

  // Get current user (for demo purposes)
  UserModelInfo get currentUser {
    print('🔍 UserService: Getting current user...');
    final user = UserModelInfo(
      id: 'current_user_demo',
      username: 'Demo User',
      email: 'demo@connecta.com',
      age: 28,
      gender: 'Male',
      nationality: 'USA',
      location: 'San Francisco',
      profileImageUrl: 'https://i.pravatar.cc/500?img=1',
      interests: ['Technology', 'Travel', 'Photography'],
      hobbies: ['Coding', 'Gaming'],
      dealBreakers: ['Smoking'],
      preferences: {},
      bio: 'Tech enthusiast and world traveler',
      isVerified: true,
      subscription: UserSubscription(),
      socialMedia: const {}
    );
    print('✅ Current user: ${user.username} (${user.id})');
    return user;
  }

  // Get user data
  Future<UserModelInfo?> getUser(String userId) async {
    print('🔍 UserService: Getting user $userId');
    final user = _users.firstWhere((u) => u.id == userId, orElse: () => currentUser);
    print('✅ Found user: ${user.username}');
    return user;
  }

  // Update user data
  Future<void> updateUser(UserModelInfo user) async {
    print('📝 UserService: Updating user ${user.id}');
    int idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user;
      print('✅ User updated successfully');
    } else {
      print('❌ User not found for update');
    }
  }

  // Get nearby users (demo: all except self)
  Stream<List<UserModelInfo>> getNearbyUsers(String userId, double radiusInMiles) async* {
    print('🔍 UserService: Getting nearby users for $userId within $radiusInMiles miles');
    final nearbyUsers = _users.where((u) => u.id != userId).toList();
    print('✅ Found ${nearbyUsers.length} nearby users');
    nearbyUsers.forEach((user) {
      print('   👤 ${user.username} (${user.id})');
    });
    yield nearbyUsers;
  }

  // Add user (for signup demo)
  Future<void> addUser(UserModelInfo user) async {
    print('➕ UserService: Adding new user ${user.id}');
    _users.add(user);
    print('✅ User added. Total users: ${_users.length}');
  }

  // Get users who liked the current user
  static Stream<List<UserModelInfo>> getLikedByUsersStream() {
    print('👀 UserService: Getting liked by users stream...');
    return MatchService.getLikedByUsersStream().map((users) {
      print('📊 UserService: Received ${users.length} users who liked me');
      // Convert User to UserModelInfo if needed
      return users.map((user) {
        print('   💕 ${user.username} liked me');
        return _convertUserToUserModelInfo(user);
      }).toList();
    });
  }

  // Get potential matches stream
  static Stream<List<UserModelInfo>> getPotentialMatchesStream({int limit = 50}) {
    print('🔍 UserService: Getting potential matches stream (limit: $limit)...');
    return MatchService.getPotentialMatchesStream(limit: limit).map((users) {
      print('📊 UserService: Received ${users.length} potential matches');
      users.forEach((user) {
        print('   🎯 Potential match: ${user.username} (${user.id})');
      });
      // Convert User to UserModelInfo if needed
      return users.map(_convertUserToUserModelInfo).toList();
    });
  }

  // Helper method to convert User to UserModelInfo
  static UserModelInfo _convertUserToUserModelInfo(UserModelInfo user) {
    return UserModelInfo(
      id: user.id,
      username: user.username,
      email: user.email,
      age: user.age,
      gender: user.gender,
      nationality: user.nationality,
      location: user.location,
      profileImageUrl: user.profileImageUrl,
      interests: user.interests,
      hobbies: user.hobbies ?? [],
      dealBreakers: user.dealBreakers ?? [],
      preferences: user.preferences ?? {},
      bio: user.bio,
      isVerified: user.isVerified,
      subscription: user.subscription,
      socialMedia: user.socialMedia ?? {},
    );
  }

  // Record user interaction
  static Future<bool> likeUser(String userId) async {
    print('❤️ UserService: Liking user $userId');
    final result = await MatchService.recordInteraction(
      toUserId: userId,
      type: InteractionType.like,
    );
    print(result ? '✅ Like recorded' : '❌ Failed to record like');
    return result;
  }

  static Future<bool> superLikeUser(String userId) async {
    print('⭐ UserService: Super liking user $userId');
    final result = await MatchService.recordInteraction(
      toUserId: userId,
      type: InteractionType.superLike,
    );
    print(result ? '✅ Super like recorded' : '❌ Failed to record super like');
    return result;
  }

  static Future<bool> loveUser(String userId) async {
    print('💖 UserService: Loving user $userId');
    final result = await MatchService.recordInteraction(
      toUserId: userId,
      type: InteractionType.love,
    );
    print(result ? '✅ Love recorded' : '❌ Failed to record love');
    return result;
  }

  static Future<bool> dislikeUser(String userId) async {
    print('👎 UserService: Disliking user $userId');
    final result = await MatchService.recordInteraction(
      toUserId: userId,
      type: InteractionType.dislike,
    );
    print(result ? '✅ Dislike recorded' : '❌ Failed to record dislike');
    return result;
  }

  // Remove interaction (for undo functionality)
  static Future<bool> undoLike(String userId) async {
    print('🔄 UserService: Undoing like for user $userId');
    final result = await MatchService.removeInteraction(
      toUserId: userId,
      type: InteractionType.like,
    );
    print(result ? '✅ Like undo successful' : '❌ Failed to undo like');
    return result;
  }

  static Future<bool> undoSuperLike(String userId) async {
    print('🔄 UserService: Undoing super like for user $userId');
    final result = await MatchService.removeInteraction(
      toUserId: userId,
      type: InteractionType.superLike,
    );
    print(result ? '✅ Super like undo successful' : '❌ Failed to undo super like');
    return result;
  }

  static Future<bool> undoLove(String userId) async {
    print('🔄 UserService: Undoing love for user $userId');
    final result = await MatchService.removeInteraction(
      toUserId: userId,
      type: InteractionType.love,
    );
    print(result ? '✅ Love undo successful' : '❌ Failed to undo love');
    return result;
  }
}