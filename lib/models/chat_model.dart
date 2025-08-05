class Chat {
  final String id;
  final String userName;
  final String lastMessage;
  final String avatarUrl;
  final DateTime lastActive;

  Chat({
    required this.id,
    required this.userName,
    required this.lastMessage,
    required this.avatarUrl,
    required this.lastActive,
  });
}

List<Chat> demoChats = [
  Chat(
    id: '1',
    userName: 'Alice',
    lastMessage: 'Hey, how are you?',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Chat(
    id: '2',
    userName: 'Bob',
    lastMessage: 'Let’s meet tomorrow!',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
  ),
  Chat(
    id: '3',
    userName: 'Cathy',
    lastMessage: 'Check out this photo!',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    lastActive: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
