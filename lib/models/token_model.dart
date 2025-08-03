class Token {
  final String userId;
  final int silverTokens;
  final int goldTokens;
  final DateTime lastClaimed;

  Token({
    required this.userId,
    required this.silverTokens,
    required this.goldTokens,
    required this.lastClaimed,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'silverTokens': silverTokens,
      'goldTokens': goldTokens,
      'lastClaimed': lastClaimed.toIso8601String(),
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      userId: map['userId'],
      silverTokens: map['silverTokens'],
      goldTokens: map['goldTokens'],
      lastClaimed: DateTime.parse(map['lastClaimed']),
    );
  }
}