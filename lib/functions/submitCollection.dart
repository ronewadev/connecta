import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileInfoTabsService {
  static final Map<String, List<String>> profileTabsData = {
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
      // Outdoor Activities
      'Hiking','Cycling','Running','Swimming','Camping','Fishing','Gardening',
      'Photography','Partying','Traveling',

      // Creative Pursuits
      'Painting','Drawing','Writing','Playing Guitar', 'Singing','Cooking',
      'Baking','Pottery', 'Knitting','DIY Crafts',

      // Indoor Activities
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

  static Future<void> initializeProfileInfoTabs() async {
    try {
      final collection = FirebaseFirestore.instance.collection('profileInfoTabs');
      final batch = FirebaseFirestore.instance.batch();
      int totalItems = 0;

      profileTabsData.forEach((category, items) {
        final docRef = collection.doc(category);
        batch.set(docRef, {
          'type': 'category',
          'items': items.map((item) => {'name': item}).toList(),
          'count': items.length,
          'createdAt': FieldValue.serverTimestamp(),
        });
        totalItems += items.length;
      });

      await batch.commit();
      print('✅ Successfully initialized ${profileTabsData.length} categories with $totalItems total items');
    } catch (e) {
      print('❌ Error initializing profileInfoTabs: $e');
      rethrow;
    }
  }
}