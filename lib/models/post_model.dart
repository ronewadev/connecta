class Post {
  final String id;
  final String userId;
  final String username;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      userId: map['userId'],
      username: map['username'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      timestamp: DateTime.parse(map['timestamp']),
      likes: map['likes'] ?? 0,
      comments: map['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'comments': comments,
    };
  }
}
