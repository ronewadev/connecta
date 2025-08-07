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
  final List<String> profileImages;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final String? bio;
  final String subscriptionType; // 'basic', 'premium', 'elite', 'infinity'
  final int goldTokens;
  final int silverTokens;
  final bool isPremium;
  final bool isElite;
  final bool isInfinity;
  final DateTime? premiumExpiry;
  final DateTime? eliteExpiryDate;
  final DateTime? infinityExpiryDate;
  final Map<String, dynamic> preferences;
  final bool isVerified;
  final bool isOnline;
  final DateTime lastActive;
  final List<String> socialMediaLinks;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    this.phone,
    this.age = 18,
    this.gender = 'Not specified',
    this.nationality = 'Not specified',
    this.location = 'Not specified',
    this.profileImageUrl,
    this.profileImages = const [],
    this.interests = const [],
    this.hobbies = const [],
    this.dealBreakers = const [],
    this.bio,
    this.subscriptionType = 'basic',
    this.goldTokens = 0,
    this.silverTokens = 0,
    this.isPremium = false,
    this.isElite = false,
    this.isInfinity = false,
    this.premiumExpiry,
    this.eliteExpiryDate,
    this.infinityExpiryDate,
    this.preferences = const {},
    this.isVerified = false,
    this.isOnline = false,
    DateTime? lastActive,
    this.socialMediaLinks = const [],
  }) : lastActive = lastActive ?? DateTime.now();

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
      profileImages: List<String>.from(map['profileImages'] ?? []),
      interests: List<String>.from(map['interests'] ?? []),
      hobbies: List<String>.from(map['hobbies'] ?? []),
      dealBreakers: List<String>.from(map['dealBreakers'] ?? []),
      bio: map['bio'],
      subscriptionType: map['subscriptionType'] ?? 'basic',
      goldTokens: map['goldTokens'] ?? 0,
      silverTokens: map['silverTokens'] ?? 0,
      isPremium: map['isPremium'] ?? false,
      isElite: map['isElite'] ?? false,
      isInfinity: map['isInfinity'] ?? false,
      premiumExpiry: map['premiumExpiry'] != null
          ? (map['premiumExpiry']).toDate()
          : null,
      eliteExpiryDate: map['eliteExpiryDate'] != null
          ? (map['eliteExpiryDate']).toDate()
          : null,
      infinityExpiryDate: map['infinityExpiryDate'] != null
          ? (map['infinityExpiryDate']).toDate()
          : null,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      isVerified: map['isVerified'] ?? false,
      isOnline: map['isOnline'] ?? false,
      lastActive: map['lastActive'] != null
          ? (map['lastActive']).toDate()
          : DateTime.now(),
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
      'profileImages': profileImages,
      'interests': interests,
      'hobbies': hobbies,
      'dealBreakers': dealBreakers,
      'bio': bio,
      'subscriptionType': subscriptionType,
      'goldTokens': goldTokens,
      'silverTokens': silverTokens,
      'isPremium': isPremium,
      'isElite': isElite,
      'isInfinity': isInfinity,
      'premiumExpiry': premiumExpiry,
      'eliteExpiryDate': eliteExpiryDate,
      'infinityExpiryDate': infinityExpiryDate,
      'preferences': preferences,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'socialMediaLinks': socialMediaLinks,
    };
  }
}