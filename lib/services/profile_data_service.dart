import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cache to avoid multiple calls
  static Map<String, List<String>>? _cachedData;
  static DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(hours: 1);

  static Future<Map<String, List<String>>> getAllProfileData() async {
    // Return cached data if still valid
    if (_cachedData != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration) {
      return _cachedData!;
    }

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('profileInfoTabs')
          .get();

      Map<String, List<String>> profileData = {};

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final category = doc.id;
        final items = data['items'] as List<dynamic>? ?? [];
        
        profileData[category] = items
            .map((item) => item['name'].toString())
            .toList();
      }

      // Cache the data
      _cachedData = profileData;
      _lastFetchTime = DateTime.now();

      return profileData;
    } catch (e) {
      print('Error fetching profile data: $e');
      // Return default data if Firebase fails
      return _getDefaultData();
    }
  }

  // Fallback data in case of network issues
  static Map<String, List<String>> _getDefaultData() {
    return {
      'interests': [
        'Drawing', 'Painting', 'Cooking', 'Baking', 'Photography', 'Videography',
        'Hiking', 'Camping', 'Rock Climbing', 'Gardening', 'Fishing',
        'Gaming', 'Reading', 'Writing', 'Poetry',
        'Music', 'Singing', 'Playing Instruments', 'Dancing',
        'Yoga', 'Meditation', 'Martial Arts', 'Fitness',
        'Cycling', 'Swimming', 'Surfing', 'Skiing', 'Traveling',
        'Astronomy', 'DIY Projects','Woodworking', 'Pottery', 'Manga', 'Collecting', 'Volunteering'
      ],
      'hobbies': [
        'Hiking','Cycling','Running','Swimming','Camping','Fishing','Gardening',
        'Photography','Partying','Traveling',
        'Painting','Drawing','Writing','Playing Guitar', 'Singing','Cooking',
        'Baking','Pottery', 'Knitting','DIY Crafts',
        'Reading', 'Chess', 'Board Games','Video Games', 'Puzzle Solving',
        'Meditation','Yoga','Gym Workouts', 'Watching Movie','Watching Anime'
      ],
      'deal_breakers': [
        'Smoking', 'Excessive Drinking', 'Unemployed', 'Bad Hygiene',
        'Doesn\'t Want Kids', 'Wants Kids', 'Religious Differences', 'Political Extremism',
        'Racism', 'Homophobia', 'Animal Cruelty', 'Emotional Unavailability', 'Commitment Issues', 'Still Married', 'Criminal Record',
        'Financial Irresponsibility', 'Controlling Behavior', 'Jealousy Issues', 'Anger Issues',
        'Dishonesty', 'Infidelity', 'Substance Abuse', 'Excessive Gaming', 'Social Media Addiction'
      ],
      'values': [
        'Family', 'Honesty', 'Loyalty', 'Ambition', 'Adventure', 'Compassion',
        'Independence', 'Creativity', 'Equality', 'Sustainability', 'Minimalism',
        'Spirituality', 'Personal Growth', 'Education', 'Health', 'Wealth',
        'Tradition', 'Innovation','Romance', 'Volunteerism',
        'Discipline', 'Patience', 'Generosity',
      ],
      'personality': [
        'Introvert', 'Extrovert', 'Ambivert', 'Analytical', 'Emotional', 'Optimistic',
        'Pessimistic', 'Realistic', 'Sensitive', 'Hustler', 'Logical', 'Creative',
        'Artistic', 'Practical', 'Theoretical', 'Spontaneous', 'Planner', 'Risk-taker',
        'Cautious', 'Competitive', 'Cooperative', 'Leader', 'Follower', 'Team Player',
        'Lone Wolf', 'Talkative', 'Quiet', 'Funny', 'Serious', 'Playful', 'Mature',
        'Innovative', 'Traditional', 'Modern', 'Rebellious', 'Conforming'
      ],
      'lifestyle': [
        'Vegetarian', 'Vegan', 'Organic', 'Cooker', 'Food Lover', 'Night Owl',
        'Early Riser', 'Active', 'Tech Lover', 'Off-grid',
        'Minimalist', 'Maximalist','Luxury Lover','Homebody', 'Social Butterfly',
        'Remote Worker', 'Office Worker', 'Shift Worker',
        'Unemployed', 'Retired', 'Student', 'Work-Life Balance',
      ],
      'relationship_types': [
        'Friendship','Open Relationship', 'Casual', 'Committed','Long Distance', 'Living Together',
        'Friends with Benefits', 'Situationship', 'Exclusive', 'Marriage'
      ],
      'education': [
        'High School', 'College','University', 'Postgraduate', 'Master\'s Degree', 'PhD'
      ]
    };
  }

  // Clear cache to force refresh
  static void clearCache() {
    _cachedData = null;
    _lastFetchTime = null;
  }

  // Get specific category data
  static Future<List<String>> getCategoryData(String category) async {
    final allData = await getAllProfileData();
    return allData[category] ?? [];
  }
}
