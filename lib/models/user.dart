class User {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final int age;
  final String gender;
  final String nationality;
  final String? profileImageUrl;
  final List<String> interests;
  final String? bio;
  final String subscriptionType; // 'basic', 'premium', 'infinity'
  final int goldTokens;
  final int silverTokens;
  final DateTime? premiumExpiry;
  final Map<String, dynamic> preferences;
  final bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.age,
    required this.gender,
    required this.nationality,
    this.profileImageUrl,
    this.interests = const [],
    this.bio,
    this.subscriptionType = 'basic',
    this.goldTokens = 0,
    this.silverTokens = 0,
    this.premiumExpiry,
    this.preferences = const {},
    this.isVerified = false,
  });

  // Add fromJson/toJson methods as needed
}