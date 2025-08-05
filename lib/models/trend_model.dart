class Trend {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int popularity;

  Trend({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.popularity = 0,
  });
}
