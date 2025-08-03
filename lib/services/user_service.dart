import '../models/user_model.dart';

class UserService {
  // Demo local user list with realistic data
  final List<User> _users = [
    User(
      id: '1',
      username: 'sarah_j',
      name: 'Sarah',
      email: 'sarah@connecta.com',
      age: 27,
      gender: 'Female',
      nationality: 'USA',
      location: 'New York',
      profileImageUrl: 'https://i.pravatar.cc/500?img=47',
      interests: ['Photography', 'Hiking', 'Art', 'Cooking'],
      bio: 'Adventure seeker and coffee enthusiast. Looking to meet new people!',
      isVerified: true,
      subscriptionType: 'premium',
      socialMediaLinks: ['facebook.com/sarah', 'instagram.com/sarah_adventures'],
    ),
    User(
      id: '2',
      username: 'michael_t',
      name: 'Michael',
      email: 'michael@connecta.com',
      age: 29,
      gender: 'Male',
      nationality: 'Canada',
      location: 'Toronto',
      profileImageUrl: 'https://i.pravatar.cc/500?img=69',
      interests: ['Fitness', 'Travel', 'Music', 'Food'],
      bio: 'Gym enthusiast and world traveler. Ask me about my last trip to Japan!',
      isVerified: true,
      socialMediaLinks: ['instagram.com/mike_travels'],
    ),
    User(
      id: '3',
      username: 'emma_w',
      name: 'Emma',
      email: 'emma@connecta.com',
      age: 24,
      gender: 'Female',
      nationality: 'UK',
      location: 'London',
      profileImageUrl: 'https://i.pravatar.cc/500?img=25',
      interests: ['Reading', 'Writing', 'Theater', 'Yoga'],
      bio: 'Bookworm and aspiring novelist. Looking for someone to share deep conversations.',
      subscriptionType: 'infinity',
    ),
    User(
      id: '4',
      username: 'david_h',
      name: 'David',
      email: 'david@connecta.com',
      age: 31,
      gender: 'Male',
      nationality: 'Australia',
      location: 'Sydney',
      profileImageUrl: 'https://i.pravatar.cc/500?img=53',
      interests: ['Surfing', 'Beach', 'BBQ', 'Rugby'],
      bio: 'Surfer and beach lover. Looking for someone to share sunset walks.',
    ),
    User(
      id: '5',
      username: 'sophia_k',
      name: 'Sophia',
      email: 'sophia@connecta.com',
      age: 26,
      gender: 'Female',
      nationality: 'France',
      location: 'Paris',
      profileImageUrl: 'https://i.pravatar.cc/500?img=32',
      interests: ['Fashion', 'Art', 'Wine Tasting', 'Cinema'],
      bio: 'Fashion designer and art enthusiast. Life is too short to wear boring clothes!',
      isVerified: true,
    ),
  ];

  // Get current user (for demo purposes)
  User get currentUser => User(
    id: 'current',
    username: 'jeniffer_c',
    name: 'Jeniffer Chil',
    email: 'jeniffer@connecta.com',
    age: 23,
    gender: 'Female',
    nationality: 'Japan',
    location: 'Tokyo',
    profileImageUrl: 'https://i.pravatar.cc/500?img=5',
    interests: ['Music', 'Travel', 'Food', 'Photography'],
    bio: 'Music lover and world explorer. Always up for new adventures!',
    isVerified: true,
    subscriptionType: 'premium',
    socialMediaLinks: ['instagram.com/jeni_adventures', 'twitter.com/jeni_c'],
  );

  // Get user data
  Future<User?> getUser(String userId) async {
    return _users.firstWhere((u) => u.id == userId, orElse: () => currentUser);
  }

  // Update user data
  Future<void> updateUser(User user) async {
    int idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      _users[idx] = user;
    }
  }

  // Get nearby users (demo: all except self)
  Stream<List<User>> getNearbyUsers(String userId, double radiusInMiles) async* {
    yield _users.where((u) => u.id != userId).toList();
  }

  // Add user (for signup demo)
  Future<void> addUser(User user) async {
    _users.add(user);
  }
}