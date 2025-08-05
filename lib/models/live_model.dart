class LiveStream {
  final String id;
  final String title;
  final String streamerName;
  final String thumbnailUrl;
  final int viewers;

  LiveStream({
    required this.id,
    required this.title,
    required this.streamerName,
    required this.thumbnailUrl,
    required this.viewers,
  });
}

List<LiveStream> demoLiveStreams = [
  LiveStream(
    id: '1',
    title: 'Music Vibes',
    streamerName: 'DJ Luna',
    thumbnailUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
    viewers: 1200,
  ),
  LiveStream(
    id: '2',
    title: 'Cooking Show',
    streamerName: 'Chef Alex',
    thumbnailUrl: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    viewers: 800,
  ),
  LiveStream(
    id: '3',
    title: 'Travel Talk',
    streamerName: 'Wanderer Mia',
    thumbnailUrl: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
    viewers: 500,
  ),
];
