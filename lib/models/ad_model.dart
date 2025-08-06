class Ad {
  final String id;
  final String title;
  final String description;
  final String brand;
  final int reward;
  final int duration; // Duration in seconds
  final String imageUrl;
  final String color; // Color as string to store hex values
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, dynamic> metadata;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.brand,
    required this.reward,
    required this.duration,
    required this.imageUrl,
    required this.color,
    required this.category,
    this.isActive = true,
    required this.createdAt,
    this.expiresAt,
    this.metadata = const {},
  });

  // Factory constructor for creating an Ad from JSON
  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      brand: map['brand'] ?? '',
      reward: map['reward'] ?? 0,
      duration: map['duration'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      color: map['color'] ?? '#000000',
      category: map['category'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      expiresAt: map['expiresAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['expiresAt'])
          : null,
      metadata: Map<String, dynamic>.from(map['metadata'] ?? {}),
    );
  }

  // Method to convert Ad to JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'brand': brand,
      'reward': reward,
      'duration': duration,
      'imageUrl': imageUrl,
      'color': color,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt?.millisecondsSinceEpoch,
      'metadata': metadata,
    };
  }

  // Copy with method for creating modified copies
  Ad copyWith({
    String? id,
    String? title,
    String? description,
    String? brand,
    int? reward,
    int? duration,
    String? imageUrl,
    String? color,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) {
    return Ad(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      reward: reward ?? this.reward,
      duration: duration ?? this.duration,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Check if ad is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Check if ad is available (active and not expired)
  bool get isAvailable {
    return isActive && !isExpired;
  }

  // Get color based on reward tier
  String get rewardBasedColor {
    if (reward >= 10) {
      return '#FF6B35'; // Premium Orange-Red for high rewards (10+ tokens)
    } else if (reward >= 8) {
      return '#9C27B0'; // Purple for high rewards (8-9 tokens)
    } else if (reward >= 6) {
      return '#2196F3'; // Blue for medium rewards (6-7 tokens)
    } else if (reward >= 4) {
      return '#4CAF50'; // Green for low-medium rewards (4-5 tokens)
    } else {
      return '#FF9800'; // Orange for low rewards (1-3 tokens)
    }
  }

  // Get reward tier name
  String get rewardTier {
    if (reward >= 10) {
      return 'Premium';
    } else if (reward >= 8) {
      return 'High';
    } else if (reward >= 6) {
      return 'Medium';
    } else if (reward >= 4) {
      return 'Standard';
    } else {
      return 'Basic';
    }
  }

  // Get formatted duration string
  String get formattedDuration {
    if (duration < 60) {
      return '${duration}s';
    } else {
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    }
  }

  // Get reward display string
  String get rewardDisplay {
    return '+$reward Silver';
  }

  @override
  String toString() {
    return 'Ad(id: $id, title: $title, brand: $brand, reward: $reward, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ad && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

// Ad categories enum for better type safety
enum AdCategory {
  fashion('Fashion'),
  technology('Technology'),
  healthFitness('Health & Fitness'),
  travel('Travel'),
  foodDining('Food & Dining'),
  gaming('Gaming'),
  education('Education'),
  entertainment('Entertainment'),
  lifestyle('Lifestyle'),
  business('Business');

  const AdCategory(this.displayName);
  final String displayName;
}

// Helper class for ad colors
class AdColors {
  static const String pink = '#E91E63';
  static const String blue = '#2196F3';
  static const String orange = '#FF9800';
  static const String teal = '#009688';
  static const String amber = '#FFC107';
  static const String purple = '#9C27B0';
  static const String green = '#4CAF50';
  static const String red = '#F44336';
  static const String indigo = '#3F51B5';
  static const String cyan = '#00BCD4';
}
