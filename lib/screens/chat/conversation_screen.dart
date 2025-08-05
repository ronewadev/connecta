import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecta/models/message_model.dart';
import 'package:connecta/models/chat_model.dart';
import 'dart:ui';

class ConversationScreen extends StatefulWidget {
  final Chat chat;

  const ConversationScreen({super.key, required this.chat});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _messages = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadDemoMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadDemoMessages() {
    // Demo messages for the conversation
    final demoMessages = [
      Message(
        id: '1',
        conversationId: '1',//widget.chat.id,
        senderId: widget.chat.userId,
        content: 'Hey there! How are you doing? 😊',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: '2',
        conversationId: '2',//widget.chat.id,
        senderId: 'currentUser',
        content: 'Hi! I\'m doing great, thanks for asking! How about you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      Message(
        id: '3',
        conversationId: '3',//widget.chat.id,
        senderId: widget.chat.userId,
        content: 'I\'m doing well too! Love your profile pictures by the way 📸',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        isRead: true,
      ),
      Message(
        id: '4',
        conversationId: '4',//widget.chat.id,
        senderId: 'currentUser',
        content: 'Aww thank you! That\'s so sweet of you to say ☺️',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        isRead: true,
      ),
      Message(
        id: '5',
        conversationId: '5',//widget.chat.id,
        senderId: widget.chat.userId,
        content: 'Would you like to grab coffee sometime? ☕',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];

    setState(() {
      _messages.addAll(demoMessages);
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: '6',//widget.chat.id,
        senderId: 'currentUser',
        content: _messageController.text.trim(),
        timestamp: DateTime.now(),
        isRead: false,
      );

      setState(() {
        _messages.add(newMessage);
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF7F7F7),
      appBar: _buildAppBar(theme, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState(theme)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe = message.senderId == 'currentUser';
                        final showAvatar = index == _messages.length - 1 ||
                            _messages[index + 1].senderId != message.senderId;
                        
                        return _buildMessageBubble(
                          message, isMe, showAvatar, theme, isDark);
                      },
                    ),
            ),
            _buildMessageInput(theme, isDark),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AppBar(
            backgroundColor: theme.colorScheme.surface.withOpacity(0.8),
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface.withOpacity(0.95),
                    theme.colorScheme.surface.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    theme.colorScheme.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: theme.colorScheme.primary,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Row(
              children: [
                Hero(
                  tag: '1',//'avatar_${widget.chat.id}',
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.chat.avatarUrl),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chat.userName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'Active now',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.phone,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice call coming soon!')),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.video,
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Video call coming soon!')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FaIcon(
              FontAwesomeIcons.commentDots,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start your conversation',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message to ${widget.chat.userName}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe, bool showAvatar, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar) ...[
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(widget.chat.avatarUrl),
            ),
            const SizedBox(width: 8),
          ] else if (!isMe) ...[
            const SizedBox(width: 32),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isMe
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: isDark
                            ? [
                                const Color(0xFF2A2A2A),
                                const Color(0xFF1F1F1F),
                              ]
                            : [
                                Colors.white,
                                Colors.grey.shade50,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isMe
                        ? theme.colorScheme.primary.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withOpacity(0.8)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        FaIcon(
                          message.isRead
                              ? FontAwesomeIcons.checkDouble
                              : FontAwesomeIcons.check,
                          size: 12,
                          color: message.isRead
                              ? theme.colorScheme.secondary
                              : Colors.white.withOpacity(0.8),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe && showAvatar) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: theme.colorScheme.primary,
              child: const FaIcon(
                FontAwesomeIcons.user,
                size: 12,
                color: Colors.white,
              ),
            ),
          ] else if (isMe) ...[
            const SizedBox(width: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF2A2A2A),
                          const Color(0xFF1F1F1F),
                        ]
                      : [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.image,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Image picker coming soon!')),
                          );
                        },
                      ),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.microphone,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Voice message coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.paperPlane,
                color: Colors.white,
                size: 18,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    
    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
