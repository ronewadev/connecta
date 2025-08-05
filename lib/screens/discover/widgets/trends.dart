import 'package:flutter/material.dart';
import 'dart:math';

import '../../../models/trend_model.dart';

class TrendsWidget extends StatelessWidget {
  final String search;
  final bool showAll;
  const TrendsWidget({super.key, this.search = '', this.showAll = false});

  List<Trend> _getDemoTrends() {
    return [
      Trend(
        id: '1',
        title: 'AI Dating',
        description: 'Find matches powered by AI.',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        popularity: 98,
      ),
      Trend(
        id: '2',
        title: 'Virtual Meetups',
        description: 'Join fun online events.',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        popularity: 85,
      ),
      Trend(
        id: '3',
        title: 'Premium Connections',
        description: 'Meet verified users.',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        popularity: 75,
      ),
      Trend(
        id: '4',
        title: 'Nearby Events',
        description: 'Discover what’s happening near you.',
        imageUrl: 'https://images.unsplash.com/photo-1465101178521-c1a4c8a0a8b7?auto=format&fit=crop&w=400&q=80',
        popularity: 60,
      ),
      Trend(
        id: '5',
        title: 'Speed Dating',
        description: 'Try fast-paced dating!',
        imageUrl: 'https://images.unsplash.com/photo-1503676382389-4809596d5290?auto=format&fit=crop&w=400&q=80',
        popularity: 70,
      ),
      Trend(
        id: '6',
        title: 'Group Chats',
        description: 'Meet people in groups.',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        popularity: 65,
      ),
      Trend(
        id: '7',
        title: 'Verified Profiles',
        description: 'Connect with real people.',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        popularity: 90,
      ),
      Trend(
        id: '8',
        title: 'Live Streams',
        description: 'Watch and interact live.',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        popularity: 80,
      ),
      Trend(
        id: '9',
        title: 'Dating Tips',
        description: 'Get advice from experts.',
        imageUrl: 'https://images.unsplash.com/photo-1465101178521-c1a4c8a0a8b7?auto=format&fit=crop&w=400&q=80',
        popularity: 55,
      ),
      Trend(
        id: '10',
        title: 'Local Hotspots',
        description: 'Find places to meet.',
        imageUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        popularity: 50,
      ),
      Trend(
        id: '11',
        title: 'Video Calls',
        description: 'Connect face-to-face.',
        imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        popularity: 77,
      ),
      Trend(
        id: '12',
        title: 'Matchmaking',
        description: 'Let us find your match.',
        imageUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        popularity: 88,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<Trend> trends = _getDemoTrends();
    if (search.isNotEmpty) {
      trends = trends.where((t) => t.title.toLowerCase().contains(search) || t.description.toLowerCase().contains(search)).toList();
    }
    if (!showAll && trends.length > 10) {
      trends.shuffle(Random());
      trends = trends.take(10).toList();
    }
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trends.length,
        itemBuilder: (context, i) {
          final trend = trends[i];
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
                      trend.imageUrl,
                      height: 120,
                      width: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      trend.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      trend.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.pink, size: 16),
                        const SizedBox(width: 4),
                        Text('${trend.popularity}%', style: TextStyle(fontSize: 12, color: Colors.pink)),
                        const Spacer(),
                        Icon(Icons.favorite, color: Colors.pink, size: 16),
                        const SizedBox(width: 2),
                        Text('${trend.popularity + 20}', style: TextStyle(fontSize: 12, color: Colors.pink)),
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
