import 'package:flutter/material.dart';
import 'dart:math';

import '../../../models/post_model.dart';

class EventsWidget extends StatelessWidget {
  final String search;
  final bool showAll;
  const EventsWidget({super.key, this.search = '', this.showAll = false});

  List<Post> _getDemoEvents() {
    return [
      Post(
        id: 'e1',
        userId: '1',
        username: 'Alice',
        content: 'Singles Mixer at Downtown Cafe',
        imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 12,
        comments: 3,
      ),
      Post(
        id: 'e2',
        userId: '2',
        username: 'Bob',
        content: 'Speed Dating at City Hall',
        imageUrl: 'https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 8,
        comments: 2,
      ),
      Post(
        id: 'e3',
        userId: '3',
        username: 'Charlie',
        content: 'Virtual Hangout Online',
        imageUrl: 'https://images.unsplash.com/photo-1465101178521-c1a4c8a0a8b7?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 15,
        comments: 5,
      ),
      Post(
        id: 'e4',
        userId: '4',
        username: 'Diana',
        content: 'Outdoor Picnic',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 10,
        comments: 1,
      ),
      Post(
        id: 'e5',
        userId: '5',
        username: 'Eve',
        content: 'Movie Night',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 20,
        comments: 7,
      ),
      Post(
        id: 'e6',
        userId: '6',
        username: 'Frank',
        content: 'Karaoke Night',
        imageUrl: 'https://images.unsplash.com/photo-1465101178521-c1a4c8a0a8b7?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 9,
        comments: 2,
      ),
      Post(
        id: 'e7',
        userId: '7',
        username: 'Grace',
        content: 'Art Exhibition',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 14,
        comments: 4,
      ),
      Post(
        id: 'e8',
        userId: '8',
        username: 'Henry',
        content: 'Tech Meetup',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 11,
        comments: 3,
      ),
      Post(
        id: 'e9',
        userId: '9',
        username: 'Ivy',
        content: 'Cooking Class',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 17,
        comments: 6,
      ),
      Post(
        id: 'e10',
        userId: '10',
        username: 'Jack',
        content: 'Book Club',
        imageUrl: 'https://images.unsplash.com/photo-1465101178521-c1a4c8a0a8b7?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 13,
        comments: 2,
      ),
      Post(
        id: 'e11',
        userId: '11',
        username: 'Kate',
        content: 'Yoga Session',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 16,
        comments: 5,
      ),
      Post(
        id: 'e12',
        userId: '12',
        username: 'Leo',
        content: 'Board Games Night',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        timestamp: DateTime.now(),
        likes: 18,
        comments: 7,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Post> events = _getDemoEvents();
    if (search.isNotEmpty) {
      events = events.where((e) => e.content.toLowerCase().contains(search) || e.username.toLowerCase().contains(search)).toList();
    }
    if (!showAll && events.length > 10) {
      events.shuffle(Random());
      events = events.take(10).toList();
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, i) {
          final e = events[i];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      e.imageUrl ?? '',
                      height: 120,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(e.content, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.pink)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('by ${e.username}', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.pink, size: 16),
                        const SizedBox(width: 4),
                        Text('${e.likes}'),
                        const SizedBox(width: 12),
                        Icon(Icons.comment, color: Colors.pink, size: 16),
                        const SizedBox(width: 4),
                        Text('${e.comments}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
