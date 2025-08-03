

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? attachmentUrl;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
    this.attachmentUrl,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      conversationId: map['conversationId'],
      senderId: map['senderId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      type: MessageType.text, // Demo only
      attachmentUrl: map['attachmentUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'attachmentUrl': attachmentUrl,
    };
  }
}

enum MessageType { text }

class ChatService {
  final List<Message> _messages = [];
  final List<Map<String, dynamic>> _conversations = [];

  Stream<List<Message>> getMessages(String conversationId) async* {
    yield _messages.where((m) => m.conversationId == conversationId).toList();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    MessageType type = MessageType.text,
    String? attachmentUrl,
  }) async {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      timestamp: DateTime.now(),
      type: type,
      attachmentUrl: attachmentUrl,
    );
    _messages.add(message);
  }

  Future<String> getOrCreateConversationId(String user1Id, String user2Id) async {
    for (final conv in _conversations) {
      final participants = List<String>.from(conv['participants']);
      if (participants.contains(user1Id) && participants.contains(user2Id)) {
        return conv['id'];
      }
    }
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    _conversations.add({
      'id': newId,
      'participants': [user1Id, user2Id],
      'createdAt': DateTime.now().toIso8601String(),
    });
    return newId;
  }
}