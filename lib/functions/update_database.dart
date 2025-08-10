import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileUpdateService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Get current user ID
  static String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  // Update timestamp helper
  static Map<String, dynamic> _withTimestamp(Map<String, dynamic> data) {
    data['lastUpdated'] = FieldValue.serverTimestamp();
    return data;
  }

  // Update interests
  static Future<bool> updateInterests(List<String> interests) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp({'interests': interests})
      );
      return true;
    } catch (e) {
      print('Error updating interests: $e');
      return false;
    }
  }

  // Update hobbies
  static Future<bool> updateHobbies(List<String> hobbies) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp({'hobbies': hobbies})
      );
      return true;
    } catch (e) {
      print('Error updating hobbies: $e');
      return false;
    }
  }

  // Update deal breakers
  static Future<bool> updateDealBreakers(List<String> dealBreakers) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp({'dealBreakers': dealBreakers})
      );
      return true;
    } catch (e) {
      print('Error updating deal breakers: $e');
      return false;
    }
  }

  // Update dating preferences
  static Future<bool> updateDatingPreferences({
    RangeValues? ageRange,
    double? distance,
    String? selectedGender,
    String? relationshipType,
    String? education,
    String? lifestyle,
  }) async {
    try {
      if (_currentUserId == null) return false;
      
      Map<String, dynamic> preferences = {};
      
      if (ageRange != null) {
        preferences['ageRange'] = {
          'min': ageRange.start.round(),
          'max': ageRange.end.round(),
        };
      }
      if (distance != null) preferences['distance'] = distance;
      if (selectedGender != null) preferences['preferredGender'] = selectedGender;
      if (relationshipType != null) preferences['relationshipType'] = relationshipType;
      if (education != null) preferences['education'] = education;
      if (lifestyle != null) preferences['lifestyle'] = lifestyle;

      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp({'preferences': preferences})
      );
      return true;
    } catch (e) {
      print('Error updating dating preferences: $e');
      return false;
    }
  }

  // Update bio
  static Future<bool> updateBio(String bio) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp({'bio': bio})
      );
      return true;
    } catch (e) {
      print('Error updating bio: $e');
      return false;
    }
  }

  // Update basic profile info
  static Future<bool> updateBasicInfo({
    String? name,
    String? username,
    int? age,
    String? gender,
    String? nationality,
    String? location,
    String? currentCity,
  }) async {
    try {
      if (_currentUserId == null) return false;
      
      Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (username != null) data['username'] = username;
      if (age != null) data['age'] = age;
      if (gender != null) data['gender'] = gender;
      if (nationality != null) data['nationality'] = nationality;
      if (location != null) data['location'] = location;
      if (currentCity != null) data['currentCity'] = currentCity;

      if (data.isNotEmpty) {
        await _firestore.collection('users').doc(_currentUserId).update(
          _withTimestamp(data)
        );
      }
      return true;
    } catch (e) {
      print('Error updating basic info: $e');
      return false;
    }
  }

  // Update Facebook link
  static Future<bool> updateFacebookLink({required bool isLinked, String? link}) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'socialMedia.facebook.isLinked': isLinked,
        'socialMedia.facebook.link': isLinked ? (link ?? '') : null,
      }));
      return true;
    } catch (e) {
      print('Error updating Facebook link: $e');
      return false;
    }
  }

  // Update Instagram link
  static Future<bool> updateInstagramLink({required bool isLinked, String? link}) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'socialMedia.instagram.isLinked': isLinked,
        'socialMedia.instagram.link': isLinked ? (link ?? '') : null,
      }));
      return true;
    } catch (e) {
      print('Error updating Instagram link: $e');
      return false;
    }
  }

  // Update X (Twitter) link
  static Future<bool> updateXLink({required bool isLinked, String? link}) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'socialMedia.x.isLinked': isLinked,
        'socialMedia.x.link': isLinked ? (link ?? '') : null,
      }));
      return true;
    } catch (e) {
      print('Error updating X link: $e');
      return false;
    }
  }

  // Update TikTok link
  static Future<bool> updateTikTokLink({required bool isLinked, String? link}) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'socialMedia.tiktok.isLinked': isLinked,
        'socialMedia.tiktok.link': isLinked ? (link ?? '') : null,
      }));
      return true;
    } catch (e) {
      print('Error updating TikTok link: $e');
      return false;
    }
  }

  // Update WhatsApp link
  static Future<bool> updateWhatsAppLink({required bool isLinked, String? link}) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'socialMedia.whatsapp.isLinked': isLinked,
        'socialMedia.whatsapp.link': isLinked ? (link ?? '') : null,
      }));
      return true;
    } catch (e) {
      print('Error updating WhatsApp link: $e');
      return false;
    }
  }

  // Generic social media update method
  static Future<bool> updateSocialMediaLink(String platform, {required bool isLinked, String? link}) async {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return updateFacebookLink(isLinked: isLinked, link: link);
      case 'instagram':
        return updateInstagramLink(isLinked: isLinked, link: link);
      case 'x':
      case 'twitter':
        return updateXLink(isLinked: isLinked, link: link);
      case 'tiktok':
        return updateTikTokLink(isLinked: isLinked, link: link);
      case 'whatsapp':
        return updateWhatsAppLink(isLinked: isLinked, link: link);
      default:
        print('Unknown social media platform: $platform');
        return false;
    }
  }

  // Bulk update method for multiple fields
  static Future<bool> updateMultipleFields(Map<String, dynamic> updates) async {
    try {
      if (_currentUserId == null) return false;
      
      await _firestore.collection('users').doc(_currentUserId).update(
        _withTimestamp(updates)
      );
      return true;
    } catch (e) {
      print('Error updating multiple fields: $e');
      return false;
    }
  }

  // Update looking for - with categorized structure
  static Future<bool> updateLookingFor(Map<String, List<String>> lookingForCategories) async {
    try {
      if (_currentUserId == null) return false;
      
      // Flatten the map into a list for backward compatibility
      List<String> flattenedLookingFor = [];
      lookingForCategories.values.forEach((list) => flattenedLookingFor.addAll(list));
      
      await _firestore.collection('users').doc(_currentUserId).update(_withTimestamp({
        'lookingFor': flattenedLookingFor,
        'lookingForCategories': lookingForCategories,
      }));
      return true;
    } catch (e) {
      print('Error updating looking for: $e');
      return false;
    }
  }
}
