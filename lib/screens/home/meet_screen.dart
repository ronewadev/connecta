import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:connecta/models/user_model.dart';
import 'package:connecta/widgets/user_card.dart';

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
          name: 'Jessica',
          email: 'jessica@email.com',
          age: 24,
          gender: 'Female',
          nationality: 'USA',
          location: 'New York',
          profileImageUrl: 'https://i.pravatar.cc/300?img=32',
          bio: 'Adventure seeker and coffee lover',
          interests: ['Hiking', 'Photography', 'Travel'],
        ),
        User(
          id: '2',
          username: 'Alex',
          name: 'Alex',
          email: 'alex@email.com',
          age: 28,
          gender: 'Male',
          nationality: 'Canada',
          location: 'Toronto',
          profileImageUrl: 'https://i.pravatar.cc/300?img=45',
          bio: 'Software developer by day, musician by night',
          interests: ['Guitar', 'Coding', 'Basketball'],
        ),
        User(
          id: '3',
          username: 'Sophia',
          name: 'Sophia',
          email: 'sophia@email.com',
          age: 22,
          gender: 'Female',
          nationality: 'France',
          location: 'Paris',
          profileImageUrl: 'https://i.pravatar.cc/300?img=12',
          bio: 'Art student with a passion for life',
          interests: ['Painting', 'Museums', 'Wine'],
        ),
        User(
          id: '4',
          username: 'Michael',
          name: 'Michael',
          email: 'michael@email.com',
          age: 30,
          gender: 'Male',
          nationality: 'Australia',
          location: 'Sydney',
          profileImageUrl: 'https://i.pravatar.cc/300?img=8',
          bio: 'Surf instructor living the beach life',
          interests: ['Surfing', 'Yoga', 'Cooking'],
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: 'return',
                  onPressed: () {
                    _swiperController.swipeLeft();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Return/Undo action')),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.undo, color: Colors.grey, size: 30),
                ),
                FloatingActionButton(
                  heroTag: 'dislike',
                  onPressed: _handleDislike,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.close, color: Colors.red, size: 30),
                ),
                FloatingActionButton(
                  heroTag: 'superlike',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Super Like!')),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                ),
                FloatingActionButton(
                  heroTag: 'love',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Love!')),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.favorite, color: Colors.pink, size: 30),
                ),
                FloatingActionButton(
                  heroTag: 'like',
                  onPressed: _handleLike,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.thumb_up, color: Colors.green, size: 30),
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