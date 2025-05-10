import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class User {
  final String id;
  final String username;
  final int age;
  final String gender;
  final String nationality;
  final String profileImageUrl;
  final String bio;
  final List<String> interests;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.age,
    required this.gender,
    required this.nationality,
    required this.profileImageUrl,
    required this.bio,
    required this.interests,
    required this.email,
  });
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                user.profileImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.username}, ${user.age}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.nationality,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(user.bio),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: user.interests
                      .map((interest) => Chip(
                    label: Text(interest),
                    backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MeetScreen extends StatefulWidget {
  const MeetScreen({super.key});

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<User> _users = [];
  bool _showLikeFeedback = false;
  bool _showDislikeFeedback = false;

  @override
  void initState() {
    super.initState();
    _loadDummyUsers();
  }

  void _loadDummyUsers() {
    setState(() {
      _users.addAll([
        User(
          id: '1',
          username: 'Jessica',
          age: 24,
          gender: 'Female',
          nationality: 'USA',
          profileImageUrl: 'https://i.pravatar.cc/300?img=32',
          bio: 'Adventure seeker and coffee lover',
          interests: ['Hiking', 'Photography', 'Travel'],
          email: 'abc@email.com',
        ),
        User(
          id: '2',
          username: 'Alex',
          age: 28,
          gender: 'Male',
          nationality: 'Canada',
          profileImageUrl: 'https://i.pravatar.cc/300?img=45',
          bio: 'Software developer by day, musician by night',
          interests: ['Guitar', 'Coding', 'Basketball'],
          email: 'abc@email.com',
        ),
        User(
          id: '3',
          username: 'Sophia',
          age: 22,
          gender: 'Female',
          nationality: 'France',
          profileImageUrl: 'https://i.pravatar.cc/300?img=12',
          bio: 'Art student with a passion for life',
          interests: ['Painting', 'Museums', 'Wine'],
          email: 'abc@email.com',
        ),
        User(
          id: '4',
          username: 'Michael',
          age: 30,
          gender: 'Male',
          nationality: 'Australia',
          profileImageUrl: 'https://i.pravatar.cc/300?img=8',
          bio: 'Surf instructor living the beach life',
          interests: ['Surfing', 'Yoga', 'Cooking'],
          email: 'abc@email.com',
        ),
      ]);
    });
  }

  void _handleLike() {
    if (_users.isEmpty) return;

    setState(() => _showLikeFeedback = true);
    HapticFeedback.lightImpact();
    _swiperController.swipeRight();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _showLikeFeedback = false);
    });
  }

  void _handleDislike() {
    if (_users.isEmpty) return;

    setState(() => _showDislikeFeedback = true);
    HapticFeedback.lightImpact();
    _swiperController.swipeLeft();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _showDislikeFeedback = false);
    });
  }

  bool _onSwipe(int index, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right) {
      _showLikeFeedback;
    } else if (direction == CardSwiperDirection.left) {
      _showDislikeFeedback;
    }
    return true;
  }



  bool _onUndo(int? previousIndex, int currentIndex, CardSwiperDirection direction) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardSwiper(
          controller: _swiperController,
          cardsCount: _users.length,
          //onSwipe: _onSwipe,
          onUndo: _onUndo,
          numberOfCardsDisplayed: 3,
          backCardOffset: const Offset(0, 0),
          padding: const EdgeInsets.all(24),
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            return UserCard(user: _users[index]);
          },
        ),

        // Feedback overlays
        if (_showLikeFeedback)
          Positioned.fill(
            child: Container(
              color: Colors.green.withOpacity(0.2),
              child: const Center(
                child: Text(
                  'LIKE',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ),

        if (_showDislikeFeedback)
          Positioned.fill(
            child: Container(
              color: Colors.red.withOpacity(0.2),
              child: const Center(
                child: Text(
                  'NOPE',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        // this is where all the dislike andlikebuttons are
        //there is a possibility that on a different phone they may appear differently, we will put  them in the persons profile widget nxt tym
        // Action buttons
        Positioned(
          bottom: 210,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: 'dislike',
                  onPressed: _handleDislike,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.close, color: Colors.red, size: 30),
                ),
                const SizedBox(width: 40),
                FloatingActionButton(
                  heroTag: 'like',
                  onPressed: _handleLike,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.favorite, color: Colors.green, size: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}

extension on CardSwiperController {
  void swipeRight() {}
  void swipeLeft() {}
}