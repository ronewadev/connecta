// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProfileInfoTabsService2 {
//   static final Map<String, List<String>> profileTabsData = {
//     'interests': [
//       'Drawing', 'Painting', 'Cooking', 'Baking', 'Photography', 'Videography',
//       'Hiking', 'Camping', 'Rock Climbing', 'Gardening', 'Fishing',
//       'Gaming', 'Reading', 'Writing', 'Poetry',
//       'Music', 'Singing', 'Playing Instruments', 'Dancing',
//       'Yoga', 'Meditation', 'Martial Arts', 'Fitness',
//       'Cycling', 'Swimming', 'Surfing', 'Skiing', 'Traveling',
//       'Astronomy', 'DIY Projects','Woodworking', 'Pottery', 'Manga', 'Collecting', 'Volunteering'
//     ],
//
//     'hobbies': [
//       // Outdoor Activities
//       'Hiking','Cycling','Running','Swimming','Camping','Fishing','Gardening',
//       'Photography','Partying','Traveling',
//
//       // Creative Pursuits
//       'Painting','Drawing','Writing','Playing Guitar', 'Singing','Cooking',
//       'Baking','Pottery', 'Knitting','DIY Crafts',
//
//       // Indoor Activities
//       'Reading', 'Chess', 'Board Games','Video Games', 'Puzzle Solving',
//       'Meditation','Yoga','Gym Workouts', 'Watching Movie','Watching Anime'
//     ],
//
//     'deal_breakers': [
//       'Smoking', 'Excessive Drinking', 'Unemployed', 'Bad Hygiene',
//       'Doesn\'t Want Kids', 'Wants Kids', 'Religious Differences', 'Political Extremism',
//       'Racism', 'Homophobia', 'Animal Cruelty', 'Emotional Unavailability', 'Commitment Issues', 'Still Married', 'Criminal Record',
//       'Financial Irresponsibility', 'Controlling Behavior', 'Jealousy Issues', 'Anger Issues',
//        'Dishonesty', 'Infidelity', 'Substance Abuse', 'Excessive Gaming', 'Social Media Addiction'
//     ],
//
//     'values': [
//       'Family', 'Honesty', 'Loyalty', 'Ambition', 'Adventure', 'Compassion',
//       'Independence', 'Creativity', 'Equality', 'Sustainability', 'Minimalism',
//       'Spirituality', 'Personal Growth', 'Education', 'Health', 'Wealth',
//       'Tradition', 'Innovation','Romance', 'Volunteerism',
//       'Discipline', 'Patience', 'Generosity',
//     ],
//
//     'personality': [
//       'Introvert', 'Extrovert', 'Ambivert', 'Analytical', 'Emotional', 'Optimistic',
//       'Pessimistic', 'Realistic', 'Sensitive', 'Hustler', 'Logical', 'Creative',
//       'Artistic', 'Practical', 'Theoretical', 'Spontaneous', 'Planner', 'Risk-taker',
//       'Cautious', 'Competitive', 'Cooperative', 'Leader', 'Follower', 'Team Player',
//       'Lone Wolf', 'Talkative', 'Quiet', 'Funny', 'Serious', 'Playful', 'Mature',
//       'Innovative', 'Traditional', 'Modern', 'Rebellious', 'Conforming'
//     ],
//
//     'lifestyle': [
//       'Vegetarian', 'Vegan', 'Organic', 'Cooker', 'Food Lover', 'Night Owl',
//       'Early Riser', 'Active', 'Tech Lover', 'Off-grid',
//       'Minimalist', 'Maximalist','Luxury Lover','Homebody', 'Social Butterfly',
//       'Remote Worker', 'Office Worker', 'Shift Worker',
//       'Unemployed', 'Retired', 'Student', 'Work-Life Balance',
//     ],
//
//     'relationship_types': [
//       'Friendship','Open Relationship', 'Casual', 'Committed','Long Distance', 'Living Together',
//       'Friends with Benefits', 'Situationship', 'Exclusive', 'Marriage'
//     ],
//
//     'education': [
//       'High School', 'College','University', 'Postgraduate', 'Master\'s Degree', 'PhD'
//     ]
//   };
//
//   static Future<void> initializeProfileInfoTabs() async {
//     try {
//       final collection = FirebaseFirestore.instance.collection('profileInfoTabs');
//       final batch = FirebaseFirestore.instance.batch();
//       int totalItems = 0;
//
//       profileTabsData.forEach((category, items) {
//         final docRef = collection.doc(category);
//         batch.set(docRef, {
//           'type': 'category',
//           'items': items.map((item) => {'name': item}).toList(),
//           'count': items.length,
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         totalItems += items.length;
//       });
//
//       await batch.commit();
//       print('✅ Successfully initialized ${profileTabsData.length} categories with $totalItems total items');
//     } catch (e) {
//       print('❌ Error initializing profileInfoTabs: $e');
//       rethrow;
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
//
// class TokenPackageService {
//   static final Map<String, Map<String, dynamic>> tokenPackages = {
//     'starterPack': {
//       'name': 'Starter Pack',
//       'goldCoins': 10,
//       'silverCoins': 20,
//       'price': 4.99,
//       'currency': 'USD',
//       'isCustom': false,
//     },
//     'popularPack': {
//       'name': 'Popular Pack',
//       'goldCoins': 25,
//       'silverCoins': 75,
//       'price': 9.99,
//       'currency': 'USD',
//       'isCustom': false,
//     },
//     'premiumPack': {
//       'name': 'Premium Pack',
//       'goldCoins': 70,
//       'silverCoins': 180,
//       'price': 19.99,
//       'currency': 'USD',
//       'isCustom': false,
//     },
//     'customTokenPack': {
//       'name': 'Custom Token Pack',
//       'minGoldCoins': 5,
//       'minSilverCoins': 10,
//       'pricePerGold': 0.50,
//       'pricePerSilver': 0.05,
//       'currency': 'USD',
//       'isCustom': true,
//     },
//   };
//
//   static Future<void> initializeTokenPackages() async {
//     try {
//       debugPrint('Starting package initialization...');
//       final collection = FirebaseFirestore.instance.collection('token_packages');
//
//       // Debug: Print Firebase app configuration
//       debugPrint('Firestore instance: ${FirebaseFirestore.instance.app.name}');
//
//       // Check if collection exists by counting documents
//       final countQuery = await collection.count().get();
//       debugPrint('Existing packages count: ${countQuery.count}');
//
//       if (countQuery.count! > 0) {
//         debugPrint('Packages already exist. Skipping initialization.');
//         return;
//       }
//
//       debugPrint('Preparing batch write...');
//       final batch = FirebaseFirestore.instance.batch();
//
//       tokenPackages.forEach((packageId, packageData) {
//         final docRef = collection.doc(packageId);
//         batch.set(docRef, {
//           ...packageData,
//           'createdAt': FieldValue.serverTimestamp(),
//           'updatedAt': FieldValue.serverTimestamp(),
//           'isActive': true,
//         });
//         debugPrint('Added to batch: $packageId');
//       });
//
//       debugPrint('Committing batch...');
//       await batch.commit();
//       debugPrint('✅ Successfully initialized ${tokenPackages.length} packages');
//     } catch (e, stack) {
//       debugPrint('❌ Initialization error: $e');
//       debugPrint('Stack trace: $stack');
//       rethrow;
//     }
//   }
//
//   static Future<bool> verifyPackagesExist() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('token_packages')
//           .limit(1)
//           .get();
//
//       return snapshot.docs.isNotEmpty;
//     } catch (e) {
//       debugPrint('Verification error: $e');
//       return false;
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionBenefitsService {
  static final Map<String, Map<String, dynamic>> subscriptionPlans = {
    'basic': {
      'name': 'Basic',
      'price': 0.00,
      'price_display': 'Free',
      'duration_days': null, // Never expires
      'features': [
        'Limited daily matches',
        'Basic filters',
        'Earn silver tokens',
        'Standard support',
      ],
      'badge': 'Basic',
    },
    'premium': {
      'name': 'Premium',
      'price': 19.99,
      'price_display': '\$19.99/month',
      'duration_days': 30,
      'features': [
        'Unlimited matches',
        'Unlimited super likes',
        'Advanced filters',
        'See who liked you',
        'Profile highlighting',
        '5 linked social media messages per month',
        '15 direct messages per month',
        '20 gold tokens monthly',
        '100 silver tokens monthly',
        'Premium Gold badge',
      ],
      'badge': 'Premium Gold',
    },
    'elite': {
      'name': 'Elite',
      'price': 49.99,
      'price_display': '\$49.99/month',
      'duration_days': 30,
      'features': [
        'All Premium features',
        'Unlimited returns',
        'Unlimited live streams',
        'Priority placement',
        'Profile boost (3x per month)',
        'Exclusive themes',
        'Unlimited direct messages',
        '15 linked social media messages per month',
        '50 gold tokens monthly',
        '200 silver tokens monthly',
        'Priority customer support',
        'Read receipts',
        'Elite Diamond badge',
      ],
      'badge': 'Elite Diamond',
    },
    'infinity': {
      'name': 'Infinity',
      'price': 99.99,
      'price_display': '\$99.99/month',
      'duration_days': 30,
      'features': [
        'All Elite features',
        'Unlimited profile boosts',
        'Unlimited linked social media messages',
        'Exclusive views & filters',
        'Advanced analytics & insights',
        'Exclusive events access',
        'Personal dating coach consultation',
        'VIP customer support',
        'Profile verification priority',
        'Custom themes & animations',
        'Video call features',
        '100 gold tokens monthly',
        '500 silver tokens monthly',
        'Travel mode',
        'Incognito browsing',
        'Infinity badge',
      ],
      'badge': 'Infinity',
    },
  };

  static Future<void> initializeSubscriptionBenefits() async {
    try {
      final collection = FirebaseFirestore.instance.collection('subscription_benefits');
      final batch = FirebaseFirestore.instance.batch();

      // Check if collection exists
      final snapshot = await collection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Subscription benefits already exist');
        return;
      }

      subscriptionPlans.forEach((planId, planData) {
        final docRef = collection.doc(planId);
        batch.set(docRef, {
          ...planData,
          'created_at': FieldValue.serverTimestamp(),
          'updated_at': FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();
      print('✅ Successfully initialized ${subscriptionPlans.length} subscription plans');
    } catch (e) {
      print('❌ Error initializing subscription benefits: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getSubscriptionBenefits() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subscription_benefits')
          .orderBy('order')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error getting subscription benefits: $e');
      return [];
    }
  }
}