import 'package:flutter/material.dart';
import 'package:connecta/models/live_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/user_model.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  UserModelInfo? currentUser;
  int currentPageIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Load current user data here
    // _loadCurrentUser();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemCount: demoLiveStreams.length,
            onPageChanged: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final stream = demoLiveStreams[index];
              return _buildLiveStreamCard(stream, theme);
            },
          ),
          _buildFloatingActionButton(),
        ],
      ),
    );
  }

  Widget _buildLiveStreamCard(LiveStream stream, ThemeData theme) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            stream.thumbnailUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.white),
                ),
              );
            },
          ),
        ),
        _buildLiveIndicator(),
        _buildViewerCount(stream),
        _buildStreamerInfo(stream, theme),
        _buildActionButtons(stream),
      ],
    );
  }

  Widget _buildLiveIndicator() {
    return Positioned(
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.circle,
              color: Colors.white,
              size: 8,
            ),
            const SizedBox(width: 6),
            const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewerCount(LiveStream stream) {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.eye,
              color: Colors.white,
              size: 12,
            ),
            const SizedBox(width: 6),
            Text(
              '${stream.viewers}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamerInfo(LiveStream stream, ThemeData theme) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Container(
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
              radius: 24,
              backgroundColor: Colors.white,
              child: FaIcon(
                FontAwesomeIcons.user,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stream.streamerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  stream.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '${stream.viewers} watching',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(LiveStream stream) {
    return Positioned(
      bottom: 100,
      right: 20,
      child: Column(
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.heart, color: Colors.white),
            onPressed: () {
              // Handle like action
              setState(() {
                // Update like count
              });
            },
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.comment, color: Colors.white),
            onPressed: () {
              // Open comment dialog
              _showCommentDialog();
            },
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.share, color: Colors.white),
            onPressed: () {
              // Share stream
              _shareStream(stream);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: const FaIcon(FontAwesomeIcons.video, color: Colors.white, size: 32),
        onPressed: () {
          _startLiveStream();
        },
      ),
    );
  }

  void _showCommentDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        const Text(
        'Comment',
        style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 16),
        TextField(
        decoration: InputDecoration(
        hintText: 'Send a comment...',
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[900],
        suffixIcon: IconButton(
        icon: const Icon(Icons.send, color: Colors.white),
        onPressed: () {
        // Send comment
        // Send comment
        },
        ),
        ),
        ),
        ],
        ),
        );
      },
    );
  }

  void _shareStream(LiveStream stream) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share Stream'),
          content: Text('Share ${stream.streamerName}\'s live stream'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stream shared!')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _startLiveStream() {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to start a live stream')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Go Live'),
          content: const Text('Start your own live stream now!'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Start'),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Live stream started! (demo)')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}