import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Linked socials model
class LinkedSocials {
  final bool whatsapp;
  final bool facebook;
  final bool x; // formerly Twitter
  final bool tiktok;
  final bool instagram;
  final bool snapchat;
  final String? whatsappLink;
  final String? facebookLink;
  final String? xLink;
  final String? tiktokLink;
  final String? instagramLink;
  final String? snapchatLink;

  LinkedSocials({
    this.whatsapp = false,
    this.facebook = false,
    this.x = false,
    this.tiktok = false,
    this.instagram = false,
    this.snapchat = false,
    this.whatsappLink,
    this.facebookLink,
    this.xLink,
    this.tiktokLink,
    this.instagramLink,
    this.snapchatLink,
  });

  factory LinkedSocials.fromMap(Map<String, dynamic> map) {
    return LinkedSocials(
      whatsapp: map['whatsapp'] ?? false,
      facebook: map['facebook'] ?? false,
      x: map['x'] ?? false,
      tiktok: map['tiktok'] ?? false,
      instagram: map['instagram'] ?? false,
      snapchat: map['snapchat'] ?? false,
      whatsappLink: map['whatsappLink'],
      facebookLink: map['facebookLink'],
      xLink: map['xLink'],
      tiktokLink: map['tiktokLink'],
      instagramLink: map['instagramLink'],
      snapchatLink: map['snapchatLink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'whatsapp': whatsapp,
      'facebook': facebook,
      'x': x,
      'tiktok': tiktok,
      'instagram': instagram,
      'snapchat': snapchat,
      'whatsappLink': whatsappLink,
      'facebookLink': facebookLink,
      'xLink': xLink,
      'tiktokLink': tiktokLink,
      'instagramLink': instagramLink,
      'snapchatLink': snapchatLink,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  LinkedSocials copyWith({
    bool? whatsapp,
    bool? facebook,
    bool? x,
    bool? tiktok,
    bool? instagram,
    bool? snapchat,
    String? whatsappLink,
    String? facebookLink,
    String? xLink,
    String? tiktokLink,
    String? instagramLink,
    String? snapchatLink,
  }) {
    return LinkedSocials(
      whatsapp: whatsapp ?? this.whatsapp,
      facebook: facebook ?? this.facebook,
      x: x ?? this.x,
      tiktok: tiktok ?? this.tiktok,
      instagram: instagram ?? this.instagram,
      snapchat: snapchat ?? this.snapchat,
      whatsappLink: whatsappLink ?? this.whatsappLink,
      facebookLink: facebookLink ?? this.facebookLink,
      xLink: xLink ?? this.xLink,
      tiktokLink: tiktokLink ?? this.tiktokLink,
      instagramLink: instagramLink ?? this.instagramLink,
      snapchatLink: snapchatLink ?? this.snapchatLink,
    );
  }
}

class UserDatabase {
  static final UserDatabase _instance = UserDatabase._internal();
  factory UserDatabase() => _instance;
  UserDatabase._internal();

  // Local cache
  UserData? _cachedUserData;
  final StreamController<UserData?> _userDataController = StreamController<UserData?>.broadcast();

  // Stream for listening to user data changes
  Stream<UserData?> get userDataStream => _userDataController.stream;

  // Get current cached user data
  UserData? get currentUserData => _cachedUserData;

  /// Fetches the latest data for the currently logged-in user from Firestore and returns it.
  Future<UserData?> fetchCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('UserDatabase: No current user found');
      return null;
    }
    
    try {
      print('UserDatabase: Fetching current user data for: ${user.uid}');
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        // Add the user ID to the data since it's not stored in the document
        data['id'] = user.uid;
        
        print('UserDatabase: Document found with keys: ${data.keys.toList()}');
        final userData = UserData.fromFirestore(data);
        _cachedUserData = userData;
        _userDataController.add(userData);
        
        print('UserDatabase: Successfully fetched data for: ${userData.username}');
        return userData;
      } else {
        print('UserDatabase: No document exists for user: ${user.uid}');
      }
    } catch (e) {
      print('Error fetching current user data: $e');
    }
    return null;
  }

  /// Prints the current user's data to the debug console (for display/testing purposes).
  Future<void> displayCurrentUserData() async {
    final userData = await fetchCurrentUserData();
    if (userData != null) {
      print('Current User Data:');
      print('Username2: [32m${userData.username}[0m');
      print('Email: ${userData.email}');
      print('Age: ${userData.age}');
      print('Gender: ${userData.gender}');
      print('Nationality: ${userData.nationality}');
      print('Bio: ${userData.bio}');
      print('Interests: ${userData.interests}');
      print('Hobbies: ${userData.hobbies}');
      print('Deal Breakers: ${userData.dealBreakers}');
      print('Looking For: ${userData.lookingFor}');
      print('Gold Tokens: ${userData.goldTokens}');
      print('Silver Tokens: ${userData.silverTokens}');
      print('Subscription: ${userData.subscriptionType}');
    } else {
      print('No user data found or user not logged in.');
    }
  }

  // Initialize and load user data on login
  Future<void> initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Only initialize if we don't have cached data
      if (_cachedUserData == null) {
        // Try to load from local storage first
        await _loadFromLocalStorage();
        
        // Then fetch fresh data from Firestore
        await _fetchFromFirestore(user.uid);
      }
      
      // Set up real-time listener if not already listening
      _setupRealtimeListener(user.uid);
    }
  }

  // Set up real-time listener for user data
  StreamSubscription<DocumentSnapshot>? _realtimeSubscription;
  
  void _setupRealtimeListener(String userId) {
    // Cancel existing subscription if it exists
    _realtimeSubscription?.cancel();
    
    print('UserDatabase: Setting up real-time listener for user: $userId');
    
    // Set up new real-time listener
    _realtimeSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        data['id'] = userId;
        
        print('UserDatabase: Real-time update received');
        final userData = UserData.fromFirestore(data);
        _cachedUserData = userData;
        
        // Save to local storage
        _saveToLocalStorage(userData);
        
        // Notify listeners
        _userDataController.add(userData);
        
        print('UserDatabase: Real-time data updated for: ${userData.username}');
      } else {
        print('UserDatabase: Document does not exist or has no data');
        _userDataController.add(null);
      }
    }, onError: (error) {
      print('UserDatabase: Real-time listener error: $error');
    });
  }

  // Load user data from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString('user_data');
      
      if (userDataJson != null) {
        final userData = UserData.fromJson(json.decode(userDataJson));
        _cachedUserData = userData;
        _userDataController.add(userData);
        print('UserDatabase: Loaded data from local storage for: ${userData.username}');
      }
    } catch (e) {
      print('Error loading from local storage: $e');
    }
  }

  // Fetch user data from Firestore
  Future<void> _fetchFromFirestore(String userId) async {
    try {
      print('UserDatabase: Fetching data for user ID: $userId');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        print('UserDatabase: Document found, parsing data...');
        final data = doc.data()!;
        // Add the user ID to the data since it's not stored in the document
        data['id'] = userId;
        
        print('UserDatabase: Raw data keys: ${data.keys.toList()}');
        
        final userData = UserData.fromFirestore(data);
        _cachedUserData = userData;
        
        // Save to local storage
        await _saveToLocalStorage(userData);
        
        // Notify listeners
        _userDataController.add(userData);
        
        print('UserDatabase: Successfully loaded data for user: ${userData.username}');
      } else {
        print('UserDatabase: No document found for user ID: $userId');
      }
    } catch (e) {
      print('Error fetching from Firestore: $e');
    }
  }

  // Save user data to local storage
  Future<void> _saveToLocalStorage(UserData userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(userData.toJson()));
    } catch (e) {
      print('Error saving to local storage: $e');
    }
  }

  // Update user data (saves to both local and Firestore)
  Future<void> updateUserData(Map<String, dynamic> updates) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updates);
      
      // Update local cache
      if (_cachedUserData != null) {
        _cachedUserData = _cachedUserData!.copyWith(updates);
        await _saveToLocalStorage(_cachedUserData!);
        _userDataController.add(_cachedUserData);
      }
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  // Update tokens
  Future<void> updateTokens({int? goldTokens, int? silverTokens}) async {
    final updates = <String, dynamic>{};
    if (goldTokens != null) updates['goldTokens'] = goldTokens;
    if (silverTokens != null) updates['silverTokens'] = silverTokens;
    
    await updateUserData(updates);
    
    // Force a local update immediately for responsive UI
    if (_cachedUserData != null) {
      _cachedUserData = _cachedUserData!.copyWith(updates);
      _userDataController.add(_cachedUserData);
      await _saveToLocalStorage(_cachedUserData!);
    }
  }

  // Update subscription
  Future<void> updateSubscription(String subscriptionType, {DateTime? expiryDate}) async {
    final updates = <String, dynamic>{
      'subscriptionType': subscriptionType,
      'isPremium': subscriptionType != 'basic',
      'isElite': subscriptionType == 'elite',
      'isInfinity': subscriptionType == 'infinity',
    };
    
    if (expiryDate != null) {
      updates['${subscriptionType}ExpiryDate'] = Timestamp.fromDate(expiryDate);
    }
    
    await updateUserData(updates);
    
    // Force a local update immediately for responsive UI
    if (_cachedUserData != null) {
      _cachedUserData = _cachedUserData!.copyWith(updates);
      _userDataController.add(_cachedUserData);
      await _saveToLocalStorage(_cachedUserData!);
    }
  }

  // Update linked socials
  Future<void> updateLinkedSocials(LinkedSocials linkedSocials) async {
    final updates = <String, dynamic>{
      'linkedSocials': linkedSocials.toMap(),
    };
    
    await updateUserData(updates);
    
    // Force a local update immediately for responsive UI
    if (_cachedUserData != null) {
      _cachedUserData = _cachedUserData!.copyWith(updates);
      _userDataController.add(_cachedUserData);
      await _saveToLocalStorage(_cachedUserData!);
    }
  }

  // Force refresh from Firestore (useful for manual refresh)
  Future<UserData?> forceRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    
    return await fetchCurrentUserData();
  }

  // Clear local data (on logout)
  Future<void> clearLocalData() async {
    _cachedUserData = null;
    _userDataController.add(null);
    
    // Cancel real-time subscription
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }

  void dispose() {
    _realtimeSubscription?.cancel();
    _userDataController.close();
  }

  // Static method for direct streaming (similar to your example)
  static Stream<UserData?> streamUser(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        data['id'] = userId;
        return UserData.fromFirestore(data);
      }
      return null;
    });
  }
}

// User data model
class UserData {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final int age;
  final String gender;
  final String nationality;
  final String bio;
  final List<String> profileImages;
  final List<String> interests;
  final List<String> hobbies;
  final List<String> dealBreakers;
  final List<String> lookingFor;
  final String subscriptionType;
  final String profileImageUrl;
  final int goldTokens;
  final int silverTokens;
  final bool isPremium;
  final bool isElite;
  final bool isInfinity;
  final DateTime? premiumExpiry;
  final DateTime? eliteExpiryDate;
  final DateTime? infinityExpiryDate;
  final List<String> socialMediaLinks;
  final LinkedSocials linkedSocials;
  final Map<String, dynamic> preferences;
  final bool rememberMe;
  final String? currentCity;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    required this.age,
    required this.gender,
    required this.nationality,
    required this.bio,
    required this.profileImages,
    required this.interests,
    required this.hobbies,
    required this.dealBreakers,
    required this.lookingFor,
    required this.subscriptionType,
    required this.profileImageUrl,
    required this.goldTokens,
    required this.silverTokens,
    required this.isPremium,
    required this.isElite,
    required this.isInfinity,
    this.premiumExpiry,
    this.eliteExpiryDate,
    this.infinityExpiryDate,
    required this.socialMediaLinks,
    LinkedSocials? linkedSocials,
    required this.preferences,
    this.rememberMe = false,
    this.currentCity,
  }) : linkedSocials = linkedSocials ?? LinkedSocials();

  factory UserData.fromFirestore(Map<String, dynamic> data) {
    print('UserData.fromFirestore: Processing data with keys: ${data.keys.toList()}');
    
    // Helper function to safely parse boolean values that might be stored as other types
    bool _safeParseBool(dynamic value, bool defaultValue) {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is List) return value.isNotEmpty;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is int) return value != 0;
      return defaultValue;
    }
    
    // Helper function to safely parse integer values
    int _safeParseInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }
    
    // Helper function to safely parse list values
    List<String> _safeParseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.map((e) => e.toString()).toList();
      if (value is String && value.isNotEmpty) return [value];
      return [];
    }
    
    return UserData(
      id: data['id'] ?? '',
      username: data['username'] ?? data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'],
      age: _safeParseInt(data['age'], 18),
      gender: data['gender'] ?? '',
      nationality: data['nationality'] ?? '',
      bio: data['bio'] ?? '',
      profileImages: _safeParseStringList(data['profileImages'] ?? (data['profileImageUrl'] != null ? [data['profileImageUrl']] : [])),
      interests: _safeParseStringList(data['interests']),
      hobbies: _safeParseStringList(data['hobbies']),
      dealBreakers: _safeParseStringList(data['dealBreakers']),
      lookingFor: _safeParseStringList(data['lookingFor']),
      subscriptionType: data['subscriptionType'] ?? 'basic',
      profileImageUrl: data['profileImageUrl'] ?? '',
      goldTokens: _safeParseInt(data['goldTokens'], 0),
      silverTokens: _safeParseInt(data['silverTokens'], 0),
      isPremium: _safeParseBool(data['isPremium'], false),
      isElite: _safeParseBool(data['isElite'], false),
      isInfinity: _safeParseBool(data['isInfinity'], false),
      premiumExpiry: data['premiumExpiry']?.toDate(),
      eliteExpiryDate: data['eliteExpiryDate']?.toDate(),
      infinityExpiryDate: data['infinityExpiryDate']?.toDate(),
      socialMediaLinks: _safeParseStringList(data['socialMediaLinks']),
      linkedSocials: data['linkedSocials'] != null 
          ? LinkedSocials.fromMap(Map<String, dynamic>.from(data['linkedSocials']))
          : LinkedSocials(),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      rememberMe: _safeParseBool(data['rememberMe'], false),
      currentCity: data['currentCity'],
    );
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      age: json['age'] ?? 18,
      gender: json['gender'] ?? '',
      nationality: json['nationality'] ?? '',
      bio: json['bio'] ?? '',
      profileImages: List<String>.from(json['profileImages'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      dealBreakers: List<String>.from(json['dealBreakers'] ?? []),
      lookingFor: List<String>.from(json['lookingFor'] ?? []),
      subscriptionType: json['subscriptionType'] ?? 'basic',
      profileImageUrl: json['profileImageUrl'] ?? '',
      goldTokens: json['goldTokens'] ?? 0,
      silverTokens: json['silverTokens'] ?? 0,
      isPremium: json['isPremium'] ?? false,
      isElite: json['isElite'] ?? false,
      isInfinity: json['isInfinity'] ?? false,
      premiumExpiry: json['premiumExpiry'] != null ? DateTime.parse(json['premiumExpiry']) : null,
      eliteExpiryDate: json['eliteExpiryDate'] != null ? DateTime.parse(json['eliteExpiryDate']) : null,
      infinityExpiryDate: json['infinityExpiryDate'] != null ? DateTime.parse(json['infinityExpiryDate']) : null,
      socialMediaLinks: List<String>.from(json['socialMediaLinks'] ?? []),
      linkedSocials: json['linkedSocials'] != null 
          ? LinkedSocials.fromMap(Map<String, dynamic>.from(json['linkedSocials']))
          : LinkedSocials(),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      rememberMe: json['rememberMe'] ?? false,
      currentCity: json['currentCity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'nationality': nationality,
      'bio': bio,
      'profileImages': profileImages,
      'interests': interests,
      'hobbies': hobbies,
      'dealBreakers': dealBreakers,
      'lookingFor': lookingFor,
      'subscriptionType': subscriptionType,
      'profileImageUrl': profileImageUrl,
      'goldTokens': goldTokens,
      'silverTokens': silverTokens,
      'linkedSocials': linkedSocials.toJson(),
      'rememberMe': rememberMe,
      'currentCity': currentCity,
    };
  }

  UserData copyWith(Map<String, dynamic> updates) {
    return UserData(
      id: updates['id'] ?? id,
      username: updates['username'] ?? username,
      email: updates['email'] ?? email,
      phone: updates['phone'] ?? phone,
      age: updates['age'] ?? age,
      gender: updates['gender'] ?? gender,
      nationality: updates['nationality'] ?? nationality,
      bio: updates['bio'] ?? bio,
      profileImages: updates['profileImages'] != null 
          ? List<String>.from(updates['profileImages']) 
          : profileImages,
      interests: updates['interests'] != null 
          ? List<String>.from(updates['interests']) 
          : interests,
      hobbies: updates['hobbies'] != null 
          ? List<String>.from(updates['hobbies']) 
          : hobbies,
      dealBreakers: updates['dealBreakers'] != null 
          ? List<String>.from(updates['dealBreakers']) 
          : dealBreakers,
      lookingFor: updates['lookingFor'] != null 
          ? List<String>.from(updates['lookingFor']) 
          : lookingFor,
      subscriptionType: updates['subscriptionType'] ?? subscriptionType,
      profileImageUrl: updates['profileImageUrl'] ?? profileImageUrl,
      goldTokens: updates['goldTokens'] ?? goldTokens,
      silverTokens: updates['silverTokens'] ?? silverTokens,
      isPremium: updates['isPremium'] ?? isPremium,
      isElite: updates['isElite'] ?? isElite,
      isInfinity: updates['isInfinity'] ?? isInfinity,
      premiumExpiry: updates['premiumExpiry'] != null 
          ? (updates['premiumExpiry'] as Timestamp).toDate() 
          : premiumExpiry,
      eliteExpiryDate: updates['eliteExpiryDate'] != null 
          ? (updates['eliteExpiryDate'] as Timestamp).toDate() 
          : eliteExpiryDate,
      infinityExpiryDate: updates['infinityExpiryDate'] != null 
          ? (updates['infinityExpiryDate'] as Timestamp).toDate() 
          : infinityExpiryDate,
      socialMediaLinks: updates['socialMediaLinks'] != null 
          ? List<String>.from(updates['socialMediaLinks']) 
          : socialMediaLinks,
      linkedSocials: updates['linkedSocials'] != null 
          ? LinkedSocials.fromMap(Map<String, dynamic>.from(updates['linkedSocials']))
          : linkedSocials,
      preferences: updates['preferences'] != null 
          ? Map<String, dynamic>.from(updates['preferences']) 
          : preferences,
      rememberMe: updates['rememberMe'] ?? rememberMe,
      currentCity: updates['currentCity'] ?? currentCity,
    );
  }
}