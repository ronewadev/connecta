import 'dart:math' as Math;

// Subscription model
class UserSubscription {
  final String type; // "basic", "premium", "elite", "infinity"
  final String status; // "active", "expired", "canceled"
  final DateTime purchaseDate;
  final DateTime? expiryDate; // null for basic
  final String paymentMethod; // "google_pay", "apple_pay", "credit_card", etc.
  final DateTime? lastRenewalDate;
  final bool autoRenew; // false for one-time purchases

  UserSubscription({
    this.type = 'basic',
    this.status = 'active',
    DateTime? purchaseDate,
    this.expiryDate,
    this.paymentMethod = '',
    this.lastRenewalDate,
    this.autoRenew = false,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  factory UserSubscription.fromMap(Map<String, dynamic> map) {
    return UserSubscription(
      type: map['type'] ?? 'basic',
      status: map['status'] ?? 'active',
      purchaseDate: map['purchaseDate'] != null
          ? (map['purchaseDate']).toDate()
          : DateTime.now(),
      expiryDate: map['expiryDate'] != null
          ? (map['expiryDate']).toDate()
          : null,
      paymentMethod: map['paymentMethod'] ?? '',
      lastRenewalDate: map['lastRenewalDate'] != null
          ? (map['lastRenewalDate']).toDate()
          : null,
      autoRenew: map['autoRenew'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'status': status,
      'purchaseDate': purchaseDate,
      'expiryDate': expiryDate,
      'paymentMethod': paymentMethod,
      'lastRenewalDate': lastRenewalDate,
      'autoRenew': autoRenew,
    };
  }
}

// Location model for storing user's location data
class UserLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;
  final String? ipAddress;
  final DateTime lastUpdated;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    this.ipAddress,
    required this.lastUpdated,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) {
    return UserLocation(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      ipAddress: map['ipAddress'],
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated']).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'ipAddress': ipAddress,
      'lastUpdated': lastUpdated,
    };
  }

  // Calculate distance to another location in kilometers
  double distanceTo(UserLocation other) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    double dLat = _toRadians(other.latitude - latitude);
    double dLon = _toRadians(other.longitude - longitude);
    double a = 
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(_toRadians(latitude)) * Math.cos(_toRadians(other.latitude)) * 
        Math.sin(dLon / 2) * Math.sin(dLon / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (Math.pi / 180);
  }
}

// User balance model
class UserBalance {
  final int goldTokens;
  final int silverTokens;
  final int superLikes;
  final int likes;
  final int loves;
  final int directMessages;
  final int socialMediaConnects;
  final int returns;

  UserBalance({
    this.goldTokens = 0,
    this.silverTokens = 0,
    this.superLikes = 0,
    this.likes = 0,
    this.loves = 0,
    this.directMessages = 0,
    this.socialMediaConnects = 0,
    this.returns = 0,
  });

  factory UserBalance.fromMap(Map<String, dynamic> map) {
    return UserBalance(
      goldTokens: map['goldTokens'] ?? 0,
      silverTokens: map['silverTokens'] ?? 0,
      superLikes: map['superLikes'] ?? 0,
      likes: map['likes'] ?? 0,
      loves: map['loves'] ?? 0,
      directMessages: map['directMessages'] ?? 0,
      socialMediaConnects: map['socialMediaConnects'] ?? 0,
      returns: map['returns'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goldTokens': goldTokens,
      'silverTokens': silverTokens,
      'superLikes': superLikes,
      'likes': likes,
      'loves': loves,
      'directMessages': directMessages,
      'socialMediaConnects': socialMediaConnects,
      'returns': returns,
    };
  }
}

class UserModelInfo {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final int age;
  final String gender;
  final String nationality;
  final String location;
  final String? currentCity;
  final UserLocation? userLocation;
  final String profileImageUrl;
  final List<String> profileImages;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final String? bio;
  final UserSubscription subscription;
  final UserBalance userBalance;
  final Map<String, dynamic> preferences;
  final bool isVerified;
  final bool isOnline;
  final DateTime lastActive;
  final Map<String, dynamic> socialMedia;
  final bool rememberMe;
  final bool allowDirectContact;
  final bool allowDirectInAppContact;
  final List<String> likesMe;
  final List<String> superLikesMe;
  final List<String> lovesMe;

  UserModelInfo({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.age = 18,
    this.gender = 'Not specified',
    this.nationality = 'Not specified',
    this.location = 'Not specified',
    this.currentCity,
    this.userLocation,
    required this.profileImageUrl,
    this.profileImages = const [],
    this.interests = const [],
    this.hobbies = const [],
    this.dealBreakers = const [],
    this.bio,
    UserSubscription? subscription,
    UserBalance? userBalance,
    this.preferences = const {},
    this.isVerified = false,
    this.isOnline = false,
    DateTime? lastActive,
    this.socialMedia = const {},
    this.rememberMe = false,
    this.allowDirectContact = false,
    this.allowDirectInAppContact = true,
    this.likesMe = const [],
    this.superLikesMe = const [],
    this.lovesMe = const [],
  }) : subscription = subscription ?? UserSubscription(),
       userBalance = userBalance ?? UserBalance(),
       lastActive = lastActive ?? DateTime.now();

  // Convenience getters for backward compatibility
  String get subscriptionType => subscription.type;
  int get goldTokens => userBalance.goldTokens;
  int get silverTokens => userBalance.silverTokens;
  bool get isPremium => subscription.type == 'premium' && subscription.status == 'active';
  bool get isElite => subscription.type == 'elite' && subscription.status == 'active';
  bool get isInfinity => subscription.type == 'infinity' && subscription.status == 'active';
  DateTime? get premiumExpiry => subscription.type == 'premium' ? subscription.expiryDate : null;
  DateTime? get eliteExpiryDate => subscription.type == 'elite' ? subscription.expiryDate : null;
  DateTime? get infinityExpiryDate => subscription.type == 'infinity' ? subscription.expiryDate : null;

  factory UserModelInfo.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModelInfo(
      id: documentId,
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      currentCity: map['city'],
      age: map['age'] ?? 18,
      gender: map['gender'] ?? 'Not specified',
      nationality: map['nationality'] ?? 'Not specified',
      location: map['location'] ?? 'Not specified',
      userLocation: map['userLocation'] != null
          ? UserLocation.fromMap(Map<String, dynamic>.from(map['userLocation']))
          : null,
      profileImageUrl: map['profileImageUrl'] ?? '',
      profileImages: List<String>.from(map['profileImages'] ?? []),
      interests: List<String>.from(map['interests'] ?? []),
      hobbies: List<String>.from(map['hobbies'] ?? []),
      dealBreakers: List<String>.from(map['dealBreakers'] ?? []),
      bio: map['bio'],
      subscription: map['subscription'] is Map<String, dynamic>
          ? UserSubscription.fromMap(Map<String, dynamic>.from(map['subscription']))
          : UserSubscription(type: map['subscription'] ?? 'basic'),
      userBalance: map['userBalance'] != null
          ? UserBalance.fromMap(Map<String, dynamic>.from(map['userBalance']))
          : UserBalance(),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      isVerified: map['isVerified'] ?? false,
      isOnline: map['isOnline'] ?? false,
      lastActive: map['lastActive'] != null
          ? (map['lastActive']).toDate()
          : DateTime.now(),
      socialMedia: Map<String, dynamic>.from(map['socialMedia'] ?? {}),
      rememberMe: map['rememberMe'] ?? false,
      allowDirectContact: map['allowDirectContact'] ?? false,
      allowDirectInAppContact: map['allowDirectInAppContact'] ?? true,
      likesMe: List<String>.from(map['likesMe'] ?? []),
      superLikesMe: List<String>.from(map['superLikesMe'] ?? []),
      lovesMe: List<String>.from(map['lovesMe'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'nationality': nationality,
      'location': location,
      'city': currentCity,
      'userLocation': userLocation?.toMap(),
      'profileImageUrl': profileImageUrl,
      'profileImages': profileImages,
      'interests': interests,
      'hobbies': hobbies,
      'dealBreakers': dealBreakers,
      'bio': bio,
      'subscription': subscription.toMap(),
      'userBalance': userBalance.toMap(),
      'preferences': preferences,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'socialMedia': socialMedia,
      'rememberMe': rememberMe,
      'allowDirectContact': allowDirectContact,
      'allowDirectInAppContact': allowDirectInAppContact,
      'likesMe': likesMe,
      'superLikesMe': superLikesMe,
      'lovesMe': lovesMe,
    };
  }
}
