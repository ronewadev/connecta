class User {
  final String id;
  final String username;
  final String name;
  final String email;
  final String? phone;
  final int age;
  final String gender;
  final String nationality;
  final String location;
  final String? profileImageUrl;
  final List<String> interests;
  final String? bio;
  final String subscriptionType; // 'basic', 'premium', 'infinity'
  final int goldTokens;
  final int silverTokens;
  final DateTime? premiumExpiry;
  final Map<String, dynamic> preferences;
  final bool isVerified;
  final bool isOnline;
  final List<String> socialMediaLinks;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.phone,
    required this.age,
    required this.gender,
    required this.nationality,
    required this.location,
    this.profileImageUrl,
    this.interests = const [],
    this.bio,
    this.subscriptionType = 'basic',
    this.goldTokens = 0,
    this.silverTokens = 0,
    this.premiumExpiry,
    this.preferences = const {},
    this.isVerified = false,
    this.isOnline = false,
    this.socialMediaLinks = const [],
  });

  factory User.fromMap(Map<String, dynamic> map, String documentId) {
    return User(
      id: documentId,
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      nationality: map['nationality'] ?? '',
      location: map['location'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      interests: List<String>.from(map['interests'] ?? []),
      bio: map['bio'],
      subscriptionType: map['subscriptionType'] ?? 'basic',
      goldTokens: map['goldTokens'] ?? 0,
      silverTokens: map['silverTokens'] ?? 0,
      premiumExpiry: map['premiumExpiry'] != null
          ? (map['premiumExpiry']).toDate()
          : null,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      isVerified: map['isVerified'] ?? false,
      isOnline: map['isOnline'] ?? false,
      socialMediaLinks: List<String>.from(map['socialMediaLinks'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'nationality': nationality,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'interests': interests,
      'bio': bio,
      'subscriptionType': subscriptionType,
      'goldTokens': goldTokens,
      'silverTokens': silverTokens,
      'premiumExpiry': premiumExpiry,
      'preferences': preferences,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'socialMediaLinks': socialMediaLinks,
    };
  }
}