import 'package:flutter/material.dart';
import '../models/ad_model.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // Demo ads data
  static List<Ad> get demoAds => [
    Ad(
      id: '1',
      title: 'Fashion Forward',
      description: 'Discover the latest fashion trends and styles',
      brand: 'StyleHub',
      reward: 5,
      duration: 30,
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Fashion',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      metadata: {
        'targetAudience': 'young_adults',
        'priority': 'medium',
        'impressions': 12543,
        'clicks': 892,
      },
    ),
    Ad(
      id: '2',
      title: 'Tech Revolution',
      description: 'Explore cutting-edge technology and gadgets',
      brand: 'TechNova',
      reward: 8,
      duration: 45,
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Technology',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      expiresAt: DateTime.now().add(const Duration(days: 15)),
      metadata: {
        'targetAudience': 'tech_enthusiasts',
        'priority': 'high',
        'impressions': 8765,
        'clicks': 1234,
      },
    ),
    Ad(
      id: '3',
      title: 'Fitness Journey',
      description: 'Transform your body with our fitness program',
      brand: 'FitLife',
      reward: 10,
      duration: 60,
      imageUrl: 'https://images.unsplash.com/photo-1571019613540-996a11b345d5?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Health & Fitness',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      expiresAt: DateTime.now().add(const Duration(days: 45)),
      metadata: {
        'targetAudience': 'fitness_lovers',
        'priority': 'high',
        'impressions': 15432,
        'clicks': 2156,
      },
    ),
    Ad(
      id: '4',
      title: 'Travel Dreams',
      description: 'Discover amazing destinations around the world',
      brand: 'WanderLust',
      reward: 7,
      duration: 35,
      imageUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Travel',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      expiresAt: DateTime.now().add(const Duration(days: 60)),
      metadata: {
        'targetAudience': 'travelers',
        'priority': 'medium',
        'impressions': 9876,
        'clicks': 743,
      },
    ),
    Ad(
      id: '5',
      title: 'Gourmet Delights',
      description: 'Indulge in exquisite culinary experiences',
      brand: 'FoodieHeaven',
      reward: 6,
      duration: 25,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Food & Dining',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      expiresAt: DateTime.now().add(const Duration(days: 20)),
      metadata: {
        'targetAudience': 'food_lovers',
        'priority': 'low',
        'impressions': 6543,
        'clicks': 456,
      },
    ),
    Ad(
      id: '6',
      title: 'Gaming Paradise',
      description: 'Experience the ultimate gaming adventure',
      brand: 'GameZone',
      reward: 12,
      duration: 75,
      imageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor
      category: 'Gaming',
      createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      expiresAt: DateTime.now().add(const Duration(days: 90)),
      metadata: {
        'targetAudience': 'gamers',
        'priority': 'high',
        'impressions': 23456,
        'clicks': 3421,
      },
    ),
    Ad(
      id: '7',
      title: 'Crypto Investment',
      description: 'Learn about cryptocurrency and blockchain technology',
      brand: 'CryptoLearn',
      reward: 3,
      duration: 15,
      imageUrl: 'https://images.unsplash.com/photo-1621761191319-c6fb62004040?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor (Basic tier)
      category: 'Finance',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(days: 10)),
      metadata: {
        'targetAudience': 'investors',
        'priority': 'low',
        'impressions': 3421,
        'clicks': 234,
      },
    ),
    Ad(
      id: '8',
      title: 'Premium Streaming',
      description: 'Enjoy unlimited entertainment with premium content',
      brand: 'StreamMax',
      reward: 15,
      duration: 90,
      imageUrl: 'https://images.unsplash.com/photo-1574375927938-d5a98e8ffe85?w=400&h=250&fit=crop',
      color: '', // Will use rewardBasedColor (Premium tier)
      category: 'Entertainment',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      metadata: {
        'targetAudience': 'entertainment_lovers',
        'priority': 'high',
        'impressions': 45678,
        'clicks': 5432,
      },
    ),
  ];

  // Get all available ads
  Future<List<Ad>> getAvailableAds() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Filter only available ads
    return demoAds.where((ad) => ad.isAvailable).toList();
  }

  // Get ads by category
  Future<List<Ad>> getAdsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return demoAds
        .where((ad) => ad.isAvailable && ad.category == category)
        .toList();
  }

  // Get ad by ID
  Future<Ad?> getAdById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return demoAds.firstWhere((ad) => ad.id == id);
    } catch (e) {
      return null;
    }
  }

  // Simulate watching an ad
  Future<bool> watchAd(String adId) async {
    final ad = await getAdById(adId);
    if (ad == null || !ad.isAvailable) {
      return false;
    }

    // Simulate ad watching process
    await Future.delayed(Duration(milliseconds: ad.duration * 100)); // Shortened for demo
    
    // In a real app, this would update analytics, user balance, etc.
    return true;
  }

  // Get featured/high-reward ads
  List<Ad> getFeaturedAds() {
    return demoAds
        .where((ad) => ad.isAvailable && ad.reward >= 8)
        .toList()
      ..sort((a, b) => b.reward.compareTo(a.reward));
  }

  // Get ads sorted by reward (highest first)
  List<Ad> getAdsSortedByReward() {
    return demoAds
        .where((ad) => ad.isAvailable)
        .toList()
      ..sort((a, b) => b.reward.compareTo(a.reward));
  }

  // Get ads sorted by duration (shortest first)
  List<Ad> getAdsSortedByDuration() {
    return demoAds
        .where((ad) => ad.isAvailable)
        .toList()
      ..sort((a, b) => a.duration.compareTo(b.duration));
  }

  // Convert hex color string to Color object
  static Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
